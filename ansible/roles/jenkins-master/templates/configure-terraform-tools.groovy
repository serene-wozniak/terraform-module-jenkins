import hudson.tools.CommandInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.*
import com.cloudbees.jenkins.plugins.customtools.CustomTool
import org.jenkinsci.plugins.terraform.TerraformInstallation
import org.jenkinsci.plugins.terraform.TerraformInstaller


def inst = Jenkins.getInstance()
CustomTool.DescriptorImpl customToolConfig = inst.getExtensionList(com.cloudbees.jenkins.plugins.customtools.CustomTool.DescriptorImpl.class)[0];


def installations = customToolConfig.installations.clone()
if (customToolConfig.byName("terrahelp") == null) {
    //Terraform not installed - add it
    def terrahelpInstaller = "if [ ! -f /var/lib/jenkins/tools/terrahelp/terrahelp ]; then\n" +
            "   mkdir -p /var/lib/jenkins/tools/terrahelp \n" +
            "   curl -L 'https://github.com/opencredo/terrahelp/releases/download/v0.4.3/terrahelp-linux-amd64' -o /var/lib/jenkins/tools/terrahelp/terrahelp\n" +
            "   chmod +x /var/lib/jenkins/tools/terrahelp/terrahelp\n" +
            "fi"
    def scriptInstaller = new CommandInstaller(null, terrahelpInstaller, "/var/lib/jenkins/tools/terrahelp")
    def terrahelpProps = new InstallSourceProperty([scriptInstaller])
    def terraformTool = new CustomTool("terrahelp", "/usr/local/bin/tools/terraform-test",[terrahelpProps] , null,null, null, "")
    customToolConfig.setInstallations(*installations, terraformTool)
}
customToolConfig.save()


def terraformVersions = [
        "terraform-0.8": "0.8.8",
        "terraform-0.9": "0.9.2"
]

def terraformInstallations = [];
for (v in terraformVersions) {
    def installer = new TerraformInstaller("${v.value}-linux-amd64")
    def installerProps = new InstallSourceProperty([installer])
    def installation = new TerraformInstallation(v.key, "", [installerProps])
    terraformInstallations.push(installation)
}


TerraformInstallation.DescriptorImpl terraformConfig = inst.getExtensionList(TerraformInstallation.DescriptorImpl.class)[0]
terraformConfig.setInstallations(*terraformInstallations)