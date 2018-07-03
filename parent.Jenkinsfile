def buildDesc = "Packer - Parent Pipeline"
def OS = ["2008R2", "2012R2", "2016"]
def lastRun;
def Destinations = ["DEN3", "DEN4", "DEN2", "SEA1", "SEA2"]

// Set up jobs
def buildOSJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    def index = i
    def osString = OS[index]
    buildOSJobs["Build OS ${OS.getAt(index)}"] = {
        build job: 'packer-BaseOS', parameters: [
        string(name: 'OSVersion', value: osString)]
    }
}

def updateJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    def index = i
    def osString = OS[index]

    updateJobs["Update OS ${OS.getAt(index)}"] = {
        build job: 'packer-Updates', parameters: [
        string(name: 'OSVersion', value: osString)],
        wait: true, propagate: false
    }
}

/* def deployJobsBatch1 = [:]
deployJobsBatch1["Deploy OS 2008R2 to DEN3"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2008R2"),
        string(name: 'DestinationVcenter', value: "DEN3")], wait: true, propagate: false

}
deployJobsBatch1["Deploy OS 2012R2 to SEA1"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2012R2"),
        string(name: 'DestinationVcenter', value: "SEA1")], wait: true, propagate: false
}
deployJobsBatch1["Deploy OS 2016 to DEN4"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2016"),
        string(name: 'DestinationVcenter', value: "DEN4")], wait: true, propagate: false
}

def deployJobsBatch2= [:]
deployJobsBatch2["Deploy OS 2008R2 to SEA1"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2008R2"),
        string(name: 'DestinationVcenter', value: "SEA1")], wait: true, propagate: false
}
deployJobsBatch2["Deploy OS 2012R2 to DEN4"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2012R2"),
        string(name: 'DestinationVcenter', value: "DEN4")], wait: true, propagate: false
}
deployJobsBatch2["Deploy OS 2016 to SEA2"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2016"),
        string(name: 'DestinationVcenter', value: "SEA2")], wait: true, propagate: false
}

def deployJobsBatch3= [:]
deployJobsBatch3["Deploy OS 2008R2 to DEN4"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2008R2"),
        string(name: 'DestinationVcenter', value: "DEN4")], wait: true, propagate: false
}
deployJobsBatch3["Deploy OS 2012R2 to SEA2"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2012R2"),
        string(name: 'DestinationVcenter', value: "SEA2")], wait: true, propagate: false
}
deployJobsBatch3["Deploy OS 2016 to DEN2"] = {
    build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "2016"),
        string(name: 'DestinationVcenter', value: "DEN2")], wait: true, propagate: false
} */

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
    stages {
        stage('Set Description') {
            steps {
                script {
                    currentBuild.description = "${buildDesc}"
                }
            }
        }
        stage('Build OS') {
            steps {
                script {
                    parallel buildOSJobs
                }
            }
        }
        stage('Update OS') {
            steps {
                script {
                    parallel updateJobs
                }
            }
        }
        stage('Deploy OS') {
            steps {
                script {
                    parallel deployJobsBatch1
                    parallel deployJobsBatch2
                    parallel deployJobsBatch3
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

