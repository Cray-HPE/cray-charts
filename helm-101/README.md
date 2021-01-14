# Helm 101

## Who should care?

Anyone currently making use of the Ansible install framework for their tool or service running in a Cray

## Where do I start?

Run the service generator for building a new helm chart in your project repo or repos. To get started with running the generator, check out [the README for the generator repo](https://stash.us.cray.com/projects/CLOUD/repos/cray-generators/browse/README.md). The tl;dr is:

```
go get -u stash.us.cray.com/cloud/craypc
```

or download craypc binary directly and place in your path

* [Linux amd64](http://car.dev.cray.com/artifactory/internal/craypc/latest/linux-amd64/craypc)
* [MacOS amd64](http://car.dev.cray.com/artifactory/internal/craypc/latest/macos-amd64/craypc)

then run:

```
craypc generators generate cray-service --sections=kubernetes
```

The above will ask you some simple questions about your project/service so that it can build the Helm chart and submit the chart back to your service repo as a pull request.

## A closer look at your generated Helm chart

Let's look at some important parts of the structure that'll be created within your project/service repo:

```
kubernetes
  [your chart]
    templates/
    tests/
    Chart.yaml
    requirements.yaml
    values.yaml
```

#### `Chart.yaml`

your chart metadata file, the values have been filled in accordingly for you here, but you're welcome to update as you go along. In fact that's the case for everything generated for you.

#### `requirements.yaml`

this is an important one, it defines the single base service chart from which your chart inherits its templates and values, the [base cray service chart](https://stash.us.cray.com/projects/CLOUD/repos/cray-charts/browse/stable/cray-service?at=refs%2Fheads%2Fmaster).

#### `values.yaml`

also important, the generator set values here to override defaults in the base chart based on how you answered questions. There's a link at the top of this generated file that helps you understand everything that can be overridden. It's also where values go if you have the need to develop your own templates and resources within your chart.

#### `templates/`

this is the standard Helm chart location for Kubernetes resource templates specific to your chart. Some teams might place custom resources in here, but our goal is to reduce the amount of custom resources individual teams need to define.

#### `tests/`

tests definitions and resources for your chart, more info on this coming soon, but know for now this is simply where we'll be able to define unit tests and otherwise that will validate your chart at build time within the DST pipeline.

## How does this stuff get built and used?

In short, if your project repo has a `/kubernetes` directory with one or many charts in it, then `dockerBuildPipeline` will pick it up and build it to a central chart repo to be used in the DST streams. These streams are then used to deploy the charts to a Cray, much like how images are built and then used in the streams and install and upgrade time.

## What else, what next?

One goal here is to reduce the amount that teams have to care about building and maintaining Kubernetes definitions moving forward. We're encapsulating common concerns in the base service chart definition in as much as possible. So, whereas the Ansible install framework has sorta left teams to their own devices to fully define all Kubernetes resources, we would prefer teams have less to care about at the infrastructure code level so they can focus more on the specific concerns of their projects.

Any team's chart can also include whatever custom stuff they want by way of putting standard helm chart templates into the `templates/` directory of your chart, but no more worrying about api gateway concerns, creating typical Cray Kubernetes resource definitions from scratch, etc.

The generated Helm chart should be it or close to it for what most teams need. If you're expecting more work than this during this transition, we're hoping we can convince you otherwise.

