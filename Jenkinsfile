@Library('dst-shared@release/shasta-1.3') _

pipeline {

  agent { node { label 'dstbuild' } }

  environment {
    PRODUCT = 'shasta-standard,shasta-premium'
    RELEASE_TAG = setReleaseTag()
  }

  stages {

    stage('Package') {
      steps {
        packageHelmCharts(chartsPath: "${env.WORKSPACE}/stable",
                          buildResultsPath: "${env.WORKSPACE}/build/results",
                          buildDate: "${env.BUILD_DATE}")
      }
    }

    stage('Publish') {
      steps {
        publishHelmCharts(chartsPath: "${env.WORKSPACE}/stable")
      }
    }

  }

  post {
    success {
      findAndTransferArtifacts()
    }
  }

}
