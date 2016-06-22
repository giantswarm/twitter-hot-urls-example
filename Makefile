
docker-build:
	docker pull python:2.7-slim
	cd twittertracker && docker build -t giantswarm/thux-twittertracker:latest .
	cd urlresolver && docker build -t giantswarm/thux-urlresolver:latest .
	cd urlresolverscaler && docker build -t giantswarm/thux-urlresolverscaler:latest .
	cd hotlistcleaner && docker build -t giantswarm/thux-hotlistcleaner:latest .
	cd frontend && docker build -t giantswarm/thux-frontend:latest .

docker-push:
	docker push giantswarm/thux-twittertracker:latest
	docker push giantswarm/thux-urlresolver:latest
	docker push giantswarm/thux-urlresolverscaler:latest
	docker push giantswarm/thux-hotlistcleaner:latest
	docker push giantswarm/thux-frontend:latest
