import jenkins.model.Jenkins
import java.util.logging.Logger


def logger = Logger.getLogger("")
Boolean installed = false
Boolean initialized = false

def pluginParameter = "{{jenkins_plugins}}"
def plugins = pluginParameter.split()
logger.info("" + plugins)


Jenkins.getInstance()


def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()



Jenkins.getInstance()

uc.updateAllSites()

plugins.each {
  logger.info("Checking " + it)
  if (!pm.getPlugin(it)) {
    logger.info("Looking UpdateCenter for " + it)
    if (!initialized) {
      uc.updateAllSites()

      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {

      logger.info("Installing " + it)
    	plugin.deploy()
      installed = true
    }
  }
}



