def buildDesc = "Packer - Deploy \\ ${OSVersion} \\ ${DestinationVCenter}"

// Function to retrieve last run status json file
def getLastJobStatus(osVersion, task) {
    lastRun = readJSON file: "${packer_build_directory}/${osVersion}-${task}-LastRun.json"
    return lastRun.Status == 'SUCCEEDED'
}

pipeline {
    agent { label 'packer-node' }
    environment {
        // Packer directories
        packer_build_directory = "D:/PackerBuilds/"
        packer_exe_path = "D:/Packer/packer.exe"
        // Sets permanent cache location for downloaded isos
        PACKER_CACHE_DIR = "D:/PackerCache/"
    }
    parameters {
        choice(
            // OS Version to build.
            name: 'OSVersion',
            choices:"2008R2\n2012R2\n2016",
            description: "Operating System Version"
        )
        choice(
            name: 'DestinationVCenter',
            choices: "DEN3\nDEN2\nSEA1\nSEA2\nDEN4",
            description: "Destination vCenter"
        )
    }
    stages {
        stage('Set Description') {
            steps {
                script {
                    currentBuild.description = "${buildDesc}"
                }
            }
        }
        stage('Deploy') {
            when {
                expression {
                    getLastJobStatus(osVersion, "Updates")
                }
            }
            steps {
                powershell '''
                    .\\deploy\\Build-Deploy.ps1 -OSVersion $env:OSVersion -OutputDirectory $env:packer_build_directory -NumTemplates 1 -DestinationVCenter $env:DestinationVCenter
                '''
            }
        }
        stage('Update Last Run When Failed') {
            when {
                expression {
                    !(getLastJobStatus(osVersion, "Updates"))
                }
            }
            steps {
                powershell '''
                    Write-Host "Updating LastRun to FAILED."
                    . .\\Helper-Functions.ps1
                    Set-LastBuild -OSVersion $env:OSVersion -Status FAILED -BuildDirectory $env:packer_build_directory -Task Deploy
                '''
                script {
                    currentBuild.result = "ABORTED"
                }
            }
        }
    }
    post {
        success {
            powershell '''
                Write-Host "Jenkins was successful!"
            '''
            // cleanWs()
        }
    }
}

