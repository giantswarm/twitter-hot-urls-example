# twitter-hot-urls-example (`thux`)

This repository features a Giant Swarm service consisting of multiple components working hand in hand to collect URLs mentioned on Twitter and create a hotlist of popular URLs.

Contents:

- [Component Overview](#component-overview)
- [Configuring the Service](#configuring-the-service)
- [Starting the Service](#starting-the-service)

## Component Overview

Checkout the `swarm.json` and the `docker-compose.yml` files for a more technical description of what this example service provides.

![Component Overview](https://github.com/giantswarm/twitter-hot-urls-example/blob/master/_docs/components-overview.png)

### twittertracker

This component consumes the Twitter Stream API, looking for tweets containing the strings `http` or `https` to fetch all tweets with links. The tweets are then parsed for contained URLs.

The URLs found are stored in the `inbox` redis database.

### inbox

This component is a simple Redis database that receives all found URLs from the `twittertracker` component. It makes use of the official Redis Docker image.

This component consciously does not provide a volume, which means that whenever this component is restarted, the database content is lost.

### urlresolver

The script inside this component reads URLs from the `inbox` Redis database and creates requests to those URLs in order to resolve redirects, to reveal the actual target URL. The resulting URL is stored in the `hotlist` Redis database.

To prevent accessing the same URL several times, a cache is maintained in the `hotlist` Redis.

The `urlresolver` component can be thought of as a worker, processing jobs from a queue. Since resolving URLs is in many cases a time-consuming job, there can be multiple instances of this component working in parallel.

### urlresolverscaler

This component contains a little script that watches the size of the `inbox` Redis database to find out if it remains constant. In case it's growing, it logs this information and tells that there shoul be more `urlresolver` instances to prevent the inbox from growing too big.

As a future improvement, the `urlresolverscaler` can be modified to actually initiate the scaling of the `urlresolver` component via the Giant Swarm API.

### hotlist

This second Redis database component stores all resolved URLs together with scoring information. It also contains the cache for the `urlresolver`. Just like the `inbox` component, we use the official Redis Docker image here.

In contrast to the `inbox` component, the `hotlist` provides a volume to persist the database throughout restarts.

### hotlistcleaner

This component contains a little helper that periodically removes outdated information from the `hotlist` Redis database.

### frontend

This is a Python/Flask web application that offers a JSON API to fetch the resulting URL hotlist.

### rebrow

The `rebrow` component offers a web-based user interface ("rebrow" stands for "redis browser") to debug the content of both Redis databases. It makes use of a third party Docker image.

## Configuring the Service

To make the service work for you, you'll have to configure a few things. The components are built so that they take all required configuration from environment variables. In addition, we make use of the possiblility to pass variables to a service definition during creation by using a variables file called `swarmvars.json`.

Please copy the provided example file `swarmvars.json.dist` to `swarmvars.json`. Then edit the details in this file as explained below.

* Set the string `myorg/myenv` to the name of the environment in which you want to run the service. If you don't work in a team with multiple users, simple use your Giant Swarm username instead of `myorg` here. Otherwise pick the organization name you need. Check out our guide on [Team Collaboration](https://docs.giantswarm.io/guides/team-collaboration/) for details. For the `myenv` part, pick an existing environment name from the chosen organization. The default here would be `dev`, so you can chose `<yourusername>/dev`.
* `DOMAIN`: The second part of the domain name used for public access to some of the components. Make this something like `mythux.gigantic.io` when working with the shared ALpha cluster of Giant Swarm. Other clusters may require a different domain name.
* `TWITTER_*`: The twitter credentials to use for the tracker. To create them, log in  to https://apps.twitter.com/ (creating a twitter account first, if needed) and create a new app. The variable names should match the terminology used by Twitter.

Save the edited `swarmvars.json` file.

## Starting the Service

Make sure you are [logged in](https://docs.giantswarm.io/reference/cli/login/) with the `swarm` CLI.

Starting the service as defined above can be done using the CLI, from the directory containing the `swarm.json` and `swarmvars.json` file. Use the following command to create and start the service:

```
swarm up
```

After a few minutes, you can check the status of the service using the command

```
swarm status
```

or using the [Giant Swarm web user interface](https://app.giantswarm.io/).
