{ config, pkgs, lib, ... }:

{
  # Platform Engineering profile
  home.packages = with pkgs; [
    # Cross-platform packages
    # Infrastructure as Code
    (terraform.withPlugins (p: with p; [
      aws
      google
      azurerm
      kubernetes
    ]))
    terragrunt
    # terraform-docs  # Build failure in current nixpkgs
    tflint
    checkov
    infracost

    # Configuration Management
    ansible
    ansible-lint

    # Kubernetes & Container Orchestration
    kubectl
    kubernetes-helm
    helmfile
    kustomize
    k9s
    kubectx
    kubeseal
    kubeval
    kubeconform
    stern
    linkerd
    fluxcd

    # Service Mesh & Networking
    istioctl
    # consul  # Requires building from source
    # envoy is Linux-only

    # CI/CD Tools
    # jenkins  # Not available on aarch64-darwin
    argocd
    tektoncd-cli

    # Cloud CLIs
    awscli2
    google-cloud-sdk
    azure-cli
    doctl  # DigitalOcean

    # Monitoring & Observability
    prometheus
    grafana-loki
    # promtool  # Not available as standalone package

    # Policy & Compliance
    # open-policy-agent  # Build failure in current nixpkgs
    conftest
    cosign
    syft
    grype

    # Secrets Management
    vault
    kubeseal  # Was: sealed-secrets-kubeseal
    sops
    age

    # Load Testing
    k6
    vegeta

    # Networking Tools
    mtr
    nmap
    tcpdump
    wireshark-cli
    iperf3
    netcat

    # Cloud Native Tools
    pack  # Cloud Native Buildpacks
    skaffold
    tilt

    # Data Tools
    postgresql
    mariadb
    redis
    # clickhouse  # Requires building from source
    apacheKafka

    # Backup & Disaster Recovery
    velero
    restic

    # Documentation
    hugo
    mdbook

    # Utilities
    yq-go
    jsonnet
    cue
    dhall
    vendir
  ];

  # Platform-specific aliases
  home.shellAliases = {
    # Kubernetes shortcuts
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
    kgp = "kubectl get pods";
    kgs = "kubectl get svc";
    kgd = "kubectl get deployments";
    kaf = "kubectl apply -f";
    kdel = "kubectl delete";
    klog = "kubectl logs -f";
    kexec = "kubectl exec -it";
    kpf = "kubectl port-forward";

    # Terraform shortcuts
    tf = "terraform";
    tfi = "terraform init";
    tfp = "terraform plan";
    tfa = "terraform apply";
    tfaa = "terraform apply -auto-approve";
    tfd = "terraform destroy";
    tfda = "terraform destroy -auto-approve";
    tfw = "terraform workspace";
    tfws = "terraform workspace select";
    tfwl = "terraform workspace list";

    # Helm shortcuts
    h = "helm";
    hi = "helm install";
    hu = "helm upgrade";
    hd = "helm delete";
    hl = "helm list";
    hs = "helm search repo";
    hr = "helm repo";
    hru = "helm repo update";

    # ArgoCD shortcuts
    argo = "argocd";
    argoapp = "argocd app";
    argosync = "argocd app sync";
    argolist = "argocd app list";

    # AWS shortcuts
    awsprofile = "export AWS_PROFILE=";
    awswho = "aws sts get-caller-identity";
    awsregion = "export AWS_REGION=";
  };

  # Platform engineering specific environment variables
  home.sessionVariables = {
    # Kubernetes
    KUBECONFIG = "$HOME/.kube/config";
    KUBE_EDITOR = "nvim";

    # Helm
    HELM_HOME = "$HOME/.helm";

    # Terraform
    TF_CLI_ARGS_plan = "-parallelism=50";
    TF_CLI_ARGS_apply = "-parallelism=50";

    # Cloud
    AWS_PAGER = "";  # Disable AWS CLI pager
    CLOUDSDK_CORE_DISABLE_PROMPTS = "1";  # Disable GCP prompts
  };

  # Additional Zsh configuration for platform tools
  programs.zsh.initContent = lib.mkAfter ''
    # Kubernetes completion
    if command -v kubectl >/dev/null 2>&1; then
      source <(kubectl completion zsh)
    fi

    # Helm completion
    if command -v helm >/dev/null 2>&1; then
      source <(helm completion zsh)
    fi

    # ArgoCD completion
    if command -v argocd >/dev/null 2>&1; then
      source <(argocd completion zsh)
    fi

    # Terraform workspace in prompt
    tf_prompt_info() {
      if [ -d .terraform ]; then
        workspace=$(terraform workspace show 2>/dev/null)
        if [ $? -eq 0 ] && [ "$workspace" != "default" ]; then
          echo " (tf:$workspace)"
        fi
      fi
    }

    # Kubernetes context in prompt
    kube_prompt_info() {
      if command -v kubectl >/dev/null 2>&1; then
        context=$(kubectl config current-context 2>/dev/null)
        if [ $? -eq 0 ]; then
          echo " (k8s:$context)"
        fi
      fi
    }
  '';
}