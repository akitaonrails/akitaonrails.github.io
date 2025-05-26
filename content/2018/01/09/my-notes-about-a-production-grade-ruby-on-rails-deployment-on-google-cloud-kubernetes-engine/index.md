---
title: My Notes about a Production-grade Ruby on Rails Deployment on Google Cloud
  Kubernetes Engine
date: '2018-01-09T20:13:00-02:00'
slug: my-notes-about-a-production-grade-ruby-on-rails-deployment-on-google-cloud-kubernetes-engine
tags:
- googlecloud
- kubernetes
- rubyonrails
- linux
- nginx
draft: false
---

I've been using Google Cloud with Kubernetes Engine for 2 months and change, from zero to production. Actually, it didn't take me a month to put it all together but it did take an extra month to figure out some nasty rough edges.

TL;DR: Google is actually doing a pretty good job being a counterbalancer so AWS doesn't slack off. If you already know everything about AWS, I'd encourage you to test out Google Cloud. Possibly because of muscle memory, I would still be more comfortable with AWS, but now that I forced myself to suffer the learning process, I am pretty confident with Google Cloud and Kubernetes for most of my scenarios.

Full disclaimer that I am not an expert, so take what I say with a grain of salt. This is one of those subjects that I am super eager to talk about but I'm also very reluctant on the proper choice of words so you don't get the wrong idea about the proposed solutions.

The goal of this exercise is mainly for me to store some snippets and thoughts for future reference. So keep in mind that this is also not a step-by-step tutorial. My first intention was to go that way, but then I realized that it would be almost like writing an entire book, so not this time.

To succeed with something like Google Cloud and Kubernetes you **must** be battle tested in infrastructure. If you never installed server-grade Linux boxes from scratch, if you never did server optimizations, if you're not comfortable with bare server-side components, do not attempt a real production deployment. Your safest bet is still something like Heroku.

You have to be that kinda person that likes to tinker (as you've probably read me doing in [previous](http://www.akitaonrails.com/linux) blog posts).

I don't know everything, but I know enough. So I only had to figure out which of the pieces would closely fit my needs. You **must** outline your needs before attempting to write your first YAML file. Planning is crucial.

First things first, this is what I wanted/needed:

* Scalable web application tier, where I could do both rolling updates (for **zero downtime** updates) and automatic and manual horizontal scaling of the servers.
* Mountable persistent storage **with** automatic snapshots/backups.
* Managed robust database (Postgresql) with automatic backups and **easy replication** to read-only instances.
* Managed solution to store secrets (such as Heroku's ENV support). Never store production configuration in the source code.
* Docker images support without me having to build custom infrastructure to deploy.
* Static external IP addresses for integrations that required a fixed IP.
* SSL termination so I could connect to CloudFlare (CDN is mandatory, but not enough, in 2018 we need some level of DDoS protection).
* Enough security by default, so everything is - in theory - lockdown unless I decide to open it.
* High-availability in different data center regions and zones.

It's easy to deploy a simple demo web application. But I didn't want a demo, I wanted a production-grade solution for the long-run. Improvements to my implementation are super welcome, so feel free to comment down below.

Some of the problems for newcomers:

* The documentation is _very_ extensive, and you will find _almost_ everything - if you know what you are looking for. Also bear in mind that Azure and AWS also implement Kubernetes with some differences, so some documentation doesn't apply to Google Cloud and vice-versa.
* There are many features in alpha, beta, and stable stages. The documentation kinda keeps up well, but most tutorials that are just a couple months old may not work as intended anymore (this one included - I am assuming Kubernetes 1.8.4-gke).
* There is a whole set of words that apply to concepts you already know but are called different. Getting used to the vocabulary may get in the way at first.
* It feels like you're playing with Lego. Lots of pieces that you can mix and match. It's easy to mess up. This means that you can build a configuration tailored to your needs. But if you just copy and paste from tutorials you **will** get stuck.
* You can do _almost_ everything through YAML files and the command line, but it's not trivial to reuse the configuration (for production and staging environments, for example). There are 3rd party tools that deal with parameterizable and reusable YAML bits, but I'd do it all by hand first. Never, ever, try automated templates in infrastructure without knowing exactly what they are doing.
* You have 2 _fat_ command line tools: `gcloud` and `kubectl`, and the confusing part is that they name some things different even though they are the same "things". At least, `kubectl` is close to `docker`, if you're familiar with that.

Once again, this is **NOT** a step-by-step tutorial. I will annotate a few steps but not everything.

### Scalable Web-Tier (the Web App itself)

The very first thing you must have is a fully 12-factors compliant web app.

Be it Ruby on Rails, Django, Laravel, Node.js or whatever. It must be a fully shared-nothing app, that does not depend on writing anything to the local filesystem. One that you can easily shutdown and startup instances independently. No old-style session in local memory or in local files (I prefer to avoid session affinity). No uploads to the local filesystem (if you must, you will have to mount an external persistent storage), always prefer to send binary streams to managed storage services.

You must have a proper [pipeline that outputs cache-busting through fingerprinting assets](https://tomanistor.com/blog/cache-bust-that-asset/) (and like it or not, Rails still has the best out-of-the-box solution in its Asset Pipeline). You don't want to worry about manually busting caches in CDNs.

Instrument your app, add [New Relic RPM](https://rpm.newrelic.com), add [Rollbar](https://rollbar.com).

Again, this is 2018, you don't want to deploy naive code with SQL (or any other input) injection, no unchecked `eval` around your code, no room for CSRF or XSS, etc. Go ahead, buy the license for [Brakeman Pro](https://brakemanpro.com/) and add it to your CI pipeline. I can wait ...

As this is not a tutorial, I will assume you're more than able to sign up to Google Cloud and find your way to set up a project, configure your region and zone.

It took me a while to wrap my head around the initial structure in Google Cloud:

* You start with a [Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects), which is the umbrella for everything your app needs.
* Then you create ["clusters"](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture). You can have a production or staging cluster, for example. Or a web cluster and a separated services cluster for non-web stuff, and so on.
* A cluster has a ["cluster-master"](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#master), which is the controller of everything else (the `gcloud` and `kubectl` commands talk to its APIs).
* A cluster has many ["node instances"](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture#nodes), the proper "machines" (or, more accurately, VM instances).
* Each cluster also has at least one ["node pool"](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools) (the "default-pool"), which is a set of node instances with the same configuration, the same ["machine-type"](https://cloud.google.com/compute/docs/machine-types).
* Finally, each node instance runs one or more "pods" which are lightweight containers like LXC. This is where your application actually is.

This is an example of [creating a cluster](https://cloud.google.com/sdk/gcloud/reference/container/clusters/create):

---
gcloud container clusters create my-web-production \
--enable-cloud-logging \
--enable-cloud-monitoring \
--machine-type n1-standard-4 \
--enable-autoupgrade \
--enable-autoscaling --max-nodes=5 --min-nodes=2 \
--num-nodes 2
---

As I mentioned, it also creates a `default-pool` with a [machine-type](https://cloud.google.com/compute/docs/machine-types) of `n1-standard-4`. Choose what combination of CPU/RAM you will need for your particular app beforehand. The type I chose has 4 vCPUs and 15GB of RAM.

By default, it starts with 3 nodes, so I chose 2 at first but auto-scalable to 5 (you can update it later if you need to, but make sure you have room for initial growth). And you can keep adding extra node-pools for differently sized node instances, let's say, for Sidekiq workers to do heavy-duty background processing. Then you should create a separated Node Pool with a different machine-type for its set of node instances, for example:

---
gcloud container node-pools create large-pool \
--cluster=my-web-production \
--node-labels=pool=large \
--machine-type=n1-highcpu-8 \
--num-nodes 1
---

This other pool controls 1 node of type `n1-highcpu-8` which has 8 vCPUs with 7.2 GB of RAM. More CPUs, less memory. You have a category of `highmem` which is less CPUs with a whole lot more memory. Again, know what you want beforehand.

The important bit here is the `--node-labels` this is how I will map the deployment to choose between Node Pools (in this case, between the `default-pool` and the `large-pool`).

Once you create a cluster, you must issue the following command to fetch its credentials:

---
gcloud container clusters get-credentials my-web-production
---

This sets the `kubectl` command as well. If you have more than one cluster (let's say, one `my-web-production` and `my-web-staging`), you must be very careful to always `get-credentials` for the correct cluster first, otherwise, you may end up running a staging deployment on the production cluster.

Because this is confusing, I modified my ZSH PROMPT to always show which cluster I am dealing with. I adapted from [zsh-kubectl-prompt](https://github.com/superbrothers/zsh-kubectl-prompt):

![zsh kubectl prompt](https://github.com/superbrothers/zsh-kubectl-prompt/raw/master/images/screenshot001.png)

As you will end up having multiple clusters in a big app, I highly recommend you add this PROMPT to your shell.

Now, how do you deploy your application to the pods within those fancy node instances?

You must have a `Dockerfile` in your application project repository to generate a Docker image. This is one example for a Ruby on Rails application:

---
FROM ruby:2.4.3
ENV RAILS_ENV production
ENV SECRET_KEY_BASE xpto
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs postgresql-client cron htop vim
ADD Gemfile* /app/
WORKDIR /app
RUN gem update bundler --pre
RUN bundle install --without development test
RUN npm install
ADD . /app
RUN cp config/database.yml.prod.example config/database.yml && cp config/application.yml.example config/application.yml
RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
---

From the Google Cloud Web Console, you will find a ["Container Registry"](https://cloud.google.com/container-registry/), which is a Private Docker Registry.

You must add the remote URL to your local config like this:

---
git remote add gcloud https://source.developers.google.com/p/my-project/r/my-app
---

Now you can `git push gcloud master`. I recommend you also add [triggers](https://cloud.google.com/container-builder/docs/running-builds/automate-builds) to tag your images. I add 2 triggers: one to tag it with `latest` and another to tag it with a random version number. You will need those later.

Once you add the registry repository as a remote on your git configuration (`git remote add`) and push to it, it should start building your Docker image with the proper tags you configured with the triggers.

Make sure your Ruby on Rails application doesn't have anything in the initializers that require a connection to the database, as it's not available. This is something you might get stuck with when your Docker build fails because of the `assets:precompile` task loaded an initializer that accidentally calls a Model - and that triggers `ActiveRecord::Base` to try to connect.

Also, make sure the Ruby version in the `Dockerfile` matches the one in `Gemfile`, otherwise it will also fail.

Notice the weird `config/application.yml` above? This is from [figaro](https://github.com/laserlemon/figaro). I also recommend you using something to make it easy to configure ENV variable in your system. I don't like Rails secrets, and it's not exactly friendly to most deployment systems after Heroku made ENV vars ubiquitous. Stick to ENV vars. Kubernetes will also thank you for that.

Now, you can override any ENV variable from the Kubernetes Deployment YAML file. Now it's a good time to show an example of that. You can name it `deploy/web.yml` or whatever suits your fancy and - of course - check it into your source code repository.

--- yaml
kind: Deployment
apiVersion: apps/v1beta1
metadata:
  name: web
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 10
  replicas: 2
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - image: gcr.io/my-project/my-app:latest
          name: my-app
          imagePullPolicy: Always
          ports:
          - containerPort: 4001
          command: ["passenger", "start", "-p", "4001", "-e", "production",
          "--max-pool-size", "2", "--min-instances", "2", "--no-friendly-error-pages"
          "--max-request-queue-time", "10", "--max-request-time", "10",
          "--pool-idle-time", "0", "--memory-limit", "300"]
          env:
            - name: "RAILS_LOG_TO_STDOUT"
              value: "true"
            - name: "RAILS_ENV"
              value: "production"
            # ... obviously reduced the many ENV vars for brevity
            - name: "REDIS_URL"
              valueFrom:
                secretKeyRef:
                  name: my-env
                  key: REDIS_URL
            - name: "SMTP_USERNAME"
              valueFrom:
                secretKeyRef:
                  name: my-env
                  key: SMTP_USERNAME
            - name: "SMTP_PASSWORD"
              valueFrom:
                secretKeyRef:
                  name: my-env
                  key: SMTP_PASSWORD
            # ... this part below is mandatory for Cloud SQL
            - name: DB_HOST
              value: 127.0.0.1
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: cloudsql-db-credentials
                  key: password
            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  name: cloudsql-db-credentials
                  key: username

        - image: gcr.io/cloudsql-docker/gce-proxy:latest
          name: cloudsql-proxy
          command: ["/cloud_sql_proxy", "--dir=/cloudsql",
                    "-instances=my-project:us-west1:my-db=tcp:5432",
                    "-credential_file=/secrets/cloudsql/credentials.json"]
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
            - name: ssl-certs
              mountPath: /etc/ssl/certs
            - name: cloudsql
              mountPath: /cloudsql
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
        - name: ssl-certs
          hostPath:
            path: /etc/ssl/certs
        - name: cloudsql
          emptyDir:
---

There is a lot going on here. So let me break it down a bit:

* The `kind`, and `apiVersion` is important, you have to keep an eye on the documentation if those change. This is what is called a [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). There used to be a Replication Controller (you will find those in old tutorials), but it's no longer in use. The recommendation is to use a [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/).
* Name things correctly, here you have `metadata:name` with `web`. Also pay close attention to `spec:template:metadata:labels` where I am labeling every pod having a label of `app: web`, you will need this to be able to select those pods later in the Service section down below.
* Then I have `spec:strategy` where we configure the Rolling Update, so if you have 10 pods, it will terminate one, boot up the new one and keep doing that, without never bringing everything down at once.
* `spec:replicas` declares how many Pods I want at once. You will have to manually calculate the machine-type of the node-pool then divide how many total CPUs/RAM you have by how much you need for each application instance.
* Remember the Docker image we generated above with the 'latest' tag? You refer to it in `spec:template:spec:containers:image`
* I am using Passenger with production configuration (check out [Phusion's documentation](https://www.phusionpassenger.com/library/config/reference/), do not just copy this).
* In the `spec:template:spec:containers:env` section I can override the ENV vars with the real production secrets. And you will notice that I can hard-code values or use this strange contraption:

--- yaml
- name: "SMTP_USERNAME"
  valueFrom:
    secretKeyRef:
      name: my-env
      key: SMTP_USERNAME
---

Now, it's referencing a ["Secret"](https://kubernetes.io/docs/concepts/configuration/secret/) storage that I named "my-env". And this is how you create your own:

---
kubectl create secret generic my-env \
--from-literal=REDIS_URL=redis://foo.com:18821 \
--from-literal=SMTP_USERNAME=foobar
---

Read the documentation as you can load text files instead of declaring everything from the command line.

As I said before, I'd rather use a managed service for a database. You can definitely load your own Docker image, but I really don't recommend it. Same goes for other database-like services such as Redis, Mongo. If you're from AWS, [Google Cloud SQL](https://cloud.google.com/sql/docs/postgres/) is like RDS.

After you create your PostgreSQL instance you can't access it directly from the web application. At the end, you have a boilerplate for a second Docker image, a ["CloudSQL Proxy"](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine). 

For that to work you must first create a Service Account:

---
gcloud sql users create proxyuser host --instance=my-db --password=abcd1234
---

After you create the PostgreSQL instance it will prompt you to download a JSON credential, so be careful and save it somewhere safe. I don't have to say that you must generate a strong secure password as well. Then you must create extra secrets:

---
kubectl create secret generic cloudsql-instance-credentials \
--from-file=credentials.json=/home/myself/downloads/my-db-12345.json

kubectl create secret generic cloudsql-db-credentials \
--from-literal=username=proxyuser --from-literal=password=abcd1234
---

These are referenced in this part of the Deployment:

--- yaml
- image: gcr.io/cloudsql-docker/gce-proxy:latest
  name: cloudsql-proxy
  command: ["/cloud_sql_proxy", "--dir=/cloudsql",
            "-instances=my-project:us-west1:my-db=tcp:5432",
            "-credential_file=/secrets/cloudsql/credentials.json"]
  volumeMounts:
    - name: cloudsql-instance-credentials
      mountPath: /secrets/cloudsql
      readOnly: true
    - name: ssl-certs
      mountPath: /etc/ssl/certs
    - name: cloudsql
      mountPath: /cloudsql
volumes:
- name: cloudsql-instance-credentials
  secret:
    secretName: cloudsql-instance-credentials
- name: ssl-certs
  hostPath:
    path: /etc/ssl/certs
- name: cloudsql
  emptyDir:
---

See that you must add the database name ("my-db" in this example) in the `-instance` clause in the command.

And by the way, the `gce-proxy:latest` refers to version 1.09 at the time when this post was published. But there already was a 1.11 version. That one gave me headaches, dropping connections and adding a super long timeout. So I went back to the 1.09 (latest) and everything worked as expected. So be aware! Not everything that is brand new is good. In infrastructure, you want to stick to stable.

You may also want the option to load a separated CloudSQL instance instead of having it in each pod, so the pods could connect to just one proxy. You may want to read [this thread](https://github.com/GoogleCloudPlatform/cloudsql-proxy/issues/49) on the subject.

It seems that nothing is exposed to anything unless you say so. So we need to expose those pods through what's called a [Node Port Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport). Let's create a `deploy/web-svc.yaml` file as well:

--- yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  sessionAffinity: None
  ports:
  - port: 80
    targetPort: 4001
    protocol: TCP
  type: NodePort
  selector:
    app: web
---

This is why I highlighted the importance of the `spec:template:metadata:labels`, so we can use it here in the `spec:selector` to select the proper pods.

We can now deploy these 2 like this:

---
kubectl create -f deploy/web.yml
kubectl create -f deploy/web-svc.yml
---

And you can see the pods being created with `kubectl get pods --watch`.

## The Load Balancer

Many tutorials will expose those pods directly through a different Service, called [Load Balancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/). I am not so sure how well this behaves under pressure and if it has SSL termination, etc. So I decided to go full blown with an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) Load Balancer using the [NGINX Controller](https://www.nginx.com/products/nginx/kubernetes-ingress-controller/), instead.

First of all, I decided to create a separated node-pool for it, for example, like this:

---
gcloud container node-pools create web-load-balancer \
--cluster=my-web-production \
--node-labels=role=load-balancer \
--machine-type=g1-small \
--num-nodes 1 \
--max-nodes 3 --min-nodes=1 \
--enable-autoscaling 
---

As when we created the example `large-pool` here you must take care of adding `--node-labels` to make the controller be installed here instead of the `default-pool`. You will need to know the node instance name, we can do it like this:

---
$ gcloud compute instances list
NAME                                             ZONE        MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP      STATUS
gke-my-web-production-default-pool-123-123       us-west1-a  n1-standard-4               10.128.0.1   123.123.123.12   RUNNING
gke-my-web-production-large-pool-123-123         us-west1-a  n1-highcpu-8                10.128.0.2   50.50.50.50      RUNNING
gke-my-web-production-web-load-balancer-123-123  us-west1-a  g1-small                    10.128.0.3   70.70.70.70      RUNNING
---

Let's save it like this for now:

---
export LB_INSTANCE_NAME=gke-my-web-production-web-load-balancer-123-123
---

You can manually reserve an external IP and give it a name like this:

---
gcloud compute addresses create ip-web-production \
        --ip-version=IPV4 \
        --global
---

For the sake of the example, let's say that it generated a reserved IP "111.111.111.111". Then let's fetch it and save it for now like this:

---
export LB_ADDRESS_IP=$(gcloud compute addresses list | grep "ip-web-production" | awk '{print $3}')
---

Finally, let's hook this address to the load balancer node instance:

---
export LB_INSTANCE_NAT=$(gcloud compute instances describe $LB_INSTANCE_NAME | grep -A3 networkInterfaces: | tail -n1 | awk -F': ' '{print $2}')
gcloud compute instances delete-access-config $LB_INSTANCE_NAME \
    --access-config-name "$LB_INSTANCE_NAT"
gcloud compute instances add-access-config $LB_INSTANCE_NAME \
    --access-config-name "$LB_INSTANCE_NAT" --address $LB_ADDRESS_IP
---

Once we do this, we can add the rest of the Ingress Deployment configuration. This will be kinda long but it's mostly boilerplate. Let's start by defining another web application that we will call `default-http-backend` that will be used to respond to HTTP requests in case our web pods are not available for some reason. Let's call it `deploy/default-web.yml`:

--- yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: default-http-backend
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: default-http-backend
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: default-http-backend
        # Any image is permissable as long as:
        # 1. It serves a 404 page at /
        # 2. It serves 200 on a /healthz endpoint
        image: gcr.io/google_containers/defaultbackend:1.0
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 30
          timeoutSeconds: 5
        ports:
        - containerPort: 8080
        resources:
          limits:
            cpu: 10m
            memory: 20Mi
          requests:
            cpu: 10m
            memory: 20Mi
---

No need to change anything here, and by now you may be familiar with the Deployment template. Again, you now know that you need to expose it through a NodePort, so let's add a `deploy/default-web-svc.yml`:

--- yaml
kind: Service
apiVersion: v1
metadata:
  name: default-http-backend
spec:
  selector:
    app: default-http-backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: NodePort
---

Again, no need to change anything. The next 3 files are the important parts. First, we will create an NGINX Load Balancer, let's call it `deploy/nginx.yml`:

--- yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  template:
    metadata:
      labels:
        k8s-app: nginx-ingress-lb
    spec:
      # hostNetwork makes it possible to use ipv6 and to preserve the source IP correctly regardless of docker configuration
      # however, it is not a hard dependency of the nginx-ingress-controller itself and it may cause issues if port 10254 already is taken on the host
      # that said, since hostPort is broken on CNI (https://github.com/kubernetes/kubernetes/issues/31307) we have to use hostNetwork where CNI is used
      hostNetwork: true
      terminationGracePeriodSeconds: 60
      nodeSelector:
        role: load-balancer
      containers:
        - args:
            - /nginx-ingress-controller
            - "--default-backend-service=$(POD_NAMESPACE)/default-http-backend"
            - "--default-ssl-certificate=$(POD_NAMESPACE)/cloudflare-secret"
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          image: "gcr.io/google_containers/nginx-ingress-controller:0.9.0-beta.5"
          imagePullPolicy: Always
          livenessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            timeoutSeconds: 5
          name: nginx-ingress-controller
          ports:
            - containerPort: 80
              name: http
              protocol: TCP
            - containerPort: 443
              name: https
              protocol: TCP
          volumeMounts:
            - mountPath: /etc/nginx-ssl/dhparam
              name: tls-dhparam-vol
      volumes:
        - name: tls-dhparam-vol
          secret:
            secretName: tls-dhparam
---

Notice the `nodeSelector` to make the node label we added when we created the new node-pool.

You may want to tinker with the labels, the number of replicas if you need to. But here you will notice that it mounts a volume that I named as `tls-dhparam-vol`. This is a [Diffie Hellman Ephemeral Parameters](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html#Forward_Secrecy_&_Diffie_Hellman_Ephemeral_Parameters). This is how we generate it:

---
sudo openssl dhparam -out ~/documents/dhparam.pem 2048

kubectl create secret generic tls-dhparam --from-file=/home/myself/documents/dhparam.pem

kubectl create secret generic tls-dhparam --from-file=/home/myself/documents/dhparam.pem
---

Also, notice that I am using version "0.9.0-beta_5" for the controller image. It works well, no problems so far. But keep an eye on release notes for newer versions as well and do your own testing.

Again, let's expose this Ingress controller through the Load Balancer Service. Let's call it `deploy/nginx-svc.yml`:

--- yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: LoadBalancer
  loadBalancerIP: 111.111.111.111
  ports:
  - name: http
    port: 80
    targetPort: http
  - name: https
    port: 443
    targetPort: https
  selector:
    k8s-app: nginx-ingress-lb
---

Remember the static external IP we have reserved above and saved in the `LB_INGRESS_IP` ENV var? This is the one we must put in the `spec:loadBalancerIP` section. This is also the IP that you will add as an "A record" in your DNS service (let's say, mapping your "www.my-app.com.br" on CloudFlare).

Finally, we can create the Ingress configuration itself, let's create a `deploy/ingress.yml` like this:

--- yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.org/ssl-services: "web-svc"
    kubernetes.io/ingress.global-static-ip-name: ip-web-production
    ingress.kubernetes.io/ssl-redirect: "true"
    ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
    - hosts:
      - www.my-app.com.br
      secretName: cloudflare-secret
  rules:
    - host: www.my-app.com.br
      http:
        paths:
        - path: /
          backend:
            serviceName: web-svc
            servicePort: 80
---

Be careful with the annotations above that hooks everything up. It binds the NodePort service we created for the web pods with the nginx ingress controller and adds SSL termination through that `spec:tls:secretName`. How do you create that? First, you must purchase an SSL certificate - again, using CloudFlare as the example.

When you finish buying, the provider should give you the secret files to download (keep them safe! a public dropbox folder is not safe!). Then you have to add it to the infrastructure like this:

---
kubectl create secret tls cloudflare-secret \
--key ~/downloads/private.pem \
--cert ~/downloads/fullchain.pem
---

Now that we edited a whole bunch of files, we can deploy the entire load balancer stack:

---
kubectl create -f deploy/default-web.yml
kubectl create -f deploy/default-web-svc.yml
kubectl create -f deploy/nginx.yml
kubectl create -f deploy/nginx-svc.yml
kubectl create -f deploy/ingress.yml
---

This NGINX Ingress configuration is based off of [Zihao Zhang's blog post](https://zihao.me/post/cheap-out-google-container-engine-load-balancer/). There is also examples in the [kubernetes incubator repository](https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/nginx-ingress.md). You may want to check it out as well.

If you did everything right so far, `https://www.my-app-com.br` should load your web application. You may want to check for Time to First-Byte (TTFB). You can do it going through CloudFlare like this:

---
curl -vso /dev/null -w "Connect: %{time_connect} \n TTFB: %{time_starttransfer} \n Total time: %{time_total} \n" https://www.my-app.com.br
---

Or, if you're having slow TTFB you can bypass CloudFlare doing this:

---
curl --resolve www.my-app.com.br:443:111.111.111.111 https://www.my-app.com.br -svo /dev/null -k -w "Connect: %{time_connect} \n TTFB: %{time_starttransfer} \n Total time: %{time_total} \n"
---

TTFB should be in the neighborhood of 1 second or less. Anything far and above could mean a problem in your application. You must check your node instance machine types, the number of workers loaded per pod, the CloudSQL proxy version, the NGINX controller version and so on. This is a trial and error procedure as far as I know. Sign up to services such as [Loader](https://loader.io) or even [Web Page Test](https://www.webpagetest.org) for insight.

## Rolling Updates

Now, that everything is up and running, how do we accomplish the Rolling Update I mentioned in the beginning? First you `git push` to the Container Registry repository and wait for the Docker image to build.

Remember that I said to let a trigger tag the image with a random version number? Let's use it (you can see it from the Build History list in the Container Registry, from the Google Cloud console):

---
kubectl set image deployment web my-app=gcr.io/my-project/my-app:1238471234g123f534f543541gf5 --record
---

You must use the same name and image that is declared in the `deploy/web.yml` from above. This will start rolling out the update by adding a new pod, then terminating one pod and so on and so forth until all of them are updated, without downtime for your users.

Rolling updates must be carried out carefully. For example, if your new deployment requires a database migration, then you must add a maintenance window (meaning: do it when there is little to no traffic, such as in the middle of the night). So you can run the migrate command like this:

---
kubectl get pods # to get a pod name

kubectl exec -it my-web-12324-121312 /app/bin/rails db:migrate

# you can also bash to a pod like this, but remember that this is an ephemeral container, so file you edit and write there disappear on the next restart:

kubectl exec -it my-web-12324-121312 bash
---

To redeploy everything without resorting to rolling update you must do this:

---
kubectl delete -f deploy/web.yml && kubectl apply -f deploy/web.yml
---

You will find a more thorough explanation in [Ta-Ching's](https://tachingchen.com/blog/Kubernetes-Rolling-Update-with-Deployment/) blog post.

## Bonus: Auto Snapshots

One item I had in my "I wanted/needed" list, in the beginning, is the ability to have persistent mountable storage with automatic backups/snapshots. Google Cloud provides half of that for the time being. You can create persistent disks to mount in your pods but it doesn't have a feature to automatically backup it. At least it does have APIs to manually snapshot it.

For this example, let's create a new SSD disk and format it first:

---
gcloud compute disks create --size 500GB my-data --type pd-ssd

gcloud compute instances list
---

The last command is so we can copy the name of a node instance. Let's say it's `gke-my-web-app-default-pool-123-123`. We will attach the `my-data` disk to it:

---
gcloud compute instances attach-disk gke-my-web-app-default-pool-123-123 --disk my-data --device-name my-data

gcloud compute ssh gke-my-web-app-default-pool-123-123
---

The last command ssh's in the instance. We can list the attached disks with `sudo lsblk` and you will see the 500GB disk, probably, as `/dev/sdb`, but make sure that's correct because we will format it!

---
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
---

Now we can exit from the SSH session and detach the disk:

---
gcloud compute instances detach-disk gke-my-web-app-default-pool-123-123 --disk my-data
---

You can mount this disk in your pods by adding the following to your deployment yaml:

---
spec:
  containers:
    - image: ...
      name: my-app
      volumeMounts:
        - name: my-data
          mountPath: /data
          # readOnly: true
   # ...
   volumes:
     - name: my-data
       gcePersistentDisk:
         pdName: my-data
         fsType: ext4
---

Now, let's create a CronJob deployment file as `deploy/auto-snapshot.yml`:

--- yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: auto-snapshot
spec:
  schedule: "0 4 * * *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: auto-snapshot
            image: grugnog/google-cloud-auto-snapshot
            command: ["/opt/entrypoint.sh"]
            env:
            - name: "GOOGLE_CLOUD_PROJECT"
              value: "my-project"
            - name: "GOOGLE_APPLICATION_CREDENTIALS"
              value: "/credential/credential.json"
            volumeMounts:
              - mountPath: /credential
                name: editor-credential
          volumes:
            - name: editor-credential
              secret:
                secretName: editor-credential
---

As we already did before, you will need to create another Service Account with editor permissions in the "IAM & admin" section of the Google Cloud console, then download the JSON credential, and finally upload it like this:

---
kubectl create secret generic editor-credential \
--from-file=credential.json=/home/myself/download/my-project-1212121.json
---

Also notice that, as a normal cron job, there is a schedule parameter that you might want to change. In the example, "0 4 * * *" means that it will run the snapshot every day at 4 AM.

Check out the [original repository](https://github.com/grugnog/google-cloud-auto-snapshot) of this solution for more details.


And this should be it for now!

As I said, in the beginning, this is not a complete procedure, just highlights of some of the important parts. If you're new to Kubernetes you just read about Deployment, Service, Ingress, but you have ReplicaSet, DaemonSet, and much more to play with.

I think this is also already too long to add a [multi-region High Availability](https://cloud.google.com/sql/docs/mysql/high-availability) setup explanation, so let's leave it at that.

Any corrections or suggestions are more than welcome as I am still in the learning process, and there is a ton of things that I still don't know myself.
