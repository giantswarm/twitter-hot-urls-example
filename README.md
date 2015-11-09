# twitter-hot-urls-example (`thux`)

This repository features a Giant Swarm service consisting of multiple components working hand in hand to collect URLs mentioned on Twitter and create a hotlist of popular URLs.

## Component Overview

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

## hotlist

This second Redis database component stores all resolved URLs together with scoring information. It also contains the cache for the `urlresolver`. Just like the `inbox` component, we use the official Redis Docker image here.

In contrast to the `inbox` component, the `hotlist` provides a volume to persist the database throughout restarts.

### hotlistcleaner

This component contains a little helper that periodically removes outdated information from the `hotlist` Redis database.

### frontend

This is a Python/Flask web application that offers a JSON API to fetch the resulting URL hotlist.

### rebrow

The `rebrow` component offers a web-based user interface ("rebrow" stands for "redis browser") to debug the content of both Redis databases. It makes use of a third party Docker image.
