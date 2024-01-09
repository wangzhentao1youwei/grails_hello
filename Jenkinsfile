pipeline{
    agent any
    environment {
        GRAILS_HOME = '/home/ec2-user/.sdkman/candidates/grails/2.5.6/bin/grails war'
        JAVA_HOME = '/usr/lib/jvm/java-1.8.0-amazon-corretto.aarch64'
    }       //构建历史保存数量
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '10', daysToKeepStr: '5'))
        timeout(time: 20, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages{

        stage('pipeline环境准备') {

            steps {
                script {
                    echo "开始构建"
                    if(!env.BRANCH_NAME.startsWith('feature-') && !env.BRANCH_NAME.startsWith('release-')){
                       // error("自动构建分支名称必须以feature-或release-开头，当前分支名称为: ${env.BRANCH_NAME}")
                    }

                    if (env.BRANCH_NAME.startsWith('feature-') ) {
                        env.env = "beta"
                    }
                    if (env.BRANCH_NAME.startsWith('release-')) {
                        env.env = "stage"
                    }

                    sh "echo 当前分支 : ${env.BRANCH_NAME}"
                    sh "echo 当前环境 : ${env.env}"
                    sh "echo 当前提交 : ${env.commit}"
                    sh "echo WORKSPACE : ${env.WORKSPACE}"
                    sh "echo GIT_BRANCH : ${env.GIT_BRANCH}"
                    sh "echo BUILD_NUMBER : ${env.BUILD_NUMBER}"
                    sh "echo JOB_NAME : ${env.JOB_NAME}"
                    sh "${JAVA_HOME}/bin/java -version"
                    sh "${GRAILS_HOME}/bin/grails -version"
                }
            }
        }

        stage("拉取代码"){
            steps {
                checkout scmGit(branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: '5bfeb44d-220d-4d2f-873e-74be3a56992c', url: 'https://github.com/wangzhentao1youwei/grails_hello.git']])
                echo '拉取成功'
            }
        }

        stage("构建"){
            steps {
                sh """
                    export JAVA_HOME=${JAVA_HOME}
                    
                    ${GRAILS_HOME}/bin/grails war
                    """
                echo '发送完成'
            }
        }
        stage("deploy"){
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'uat', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''
                sudo service tomcat stop
                sudo rm -rf /mnt/tomcat/webapps/web
                sudo cp target/web.war /mnt/tomcat/webapps
                sudo chmod o+w /mnt/tomcat/*
                sudo chmod o+w /mnt/bizweb/log/bizweb.log
                sudo service tomcat start''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'target/web.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])



                echo 'deploy success..........'
            }
        }

    }
    post{
        always{
            echo 'always say goodbay'
        }
    }
}
