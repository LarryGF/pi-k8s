# Home Assistant (https://www.home-assistant.io/)
resource "helm_release" "home-asssitant" {
  name       = "home-assistant"
  chart      = "home-assistant"
  repository = "https://k8s-at-home.com/charts/"

  values = [file("../helm/home-assistant/home-assistant-values.yaml")]

  set {
    name = "env.TZ"
    value = var.timezone 
  }

  set {
    name = "addons.codeserver.git.deployKeyBase64"
    value = base64encode(file("~/.ssh/id_rsa"))
  }

  depends_on = []
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true
  timeout = 600
}

resource "helm_release" "duckdns" {
  name       = "duckdns-go"
  chart      = "duckdns-go"
  repository = "https://ebrianne.github.io/helm-charts"

  values = [ templatefile("../helm/duckdns/duckdns-values.yaml",
  {
      token = var.duckdns_token
      domains = var.duckdns_domains
  })]

  depends_on = []
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true
  timeout = 600
}

# Adguard Home (https://adguard.com/adguard-home.html)
resource "helm_release" "adguard-home" {
  name       = "adguard"
  chart      = "adguard-home"
  repository = "https://k8s-at-home.com/charts/"

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  
  values = [file("../helm/adguard/adguard-values.yaml")]

  recreate_pods = true

  depends_on = []
}