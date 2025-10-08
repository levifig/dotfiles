{ config, pkgs, lib, ... }:

{
  # Centralized shell aliases for all configurations
  # Aliases are conditionally applied based on package availability

  home.shellAliases = {
    # ============================================
    # Navigation
    # ============================================
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    dev = "cd ~/Development";
    proj = "cd ~/Development/Projects";
    dots = "cd ~/.dotfiles";
    conf = "cd ~/.config";

    # ============================================
    # System & File Operations
    # ============================================
    reload = "source ~/.zshrc";
    zr = "source ~/.config/zsh/zshrc";
    zshconfig = "nvim ~/.config/zsh/.zshrc";
    nixconfig = "nvim ~/.dotfiles/home-manager/hosts/LFX001.nix";

    # Safe operations with confirmation
    mv = "mv -iv";
    cp = "cp -riv";
    rm = "rm -i";
    mkdir = "mkdir -vp";

    # Clipboard (macOS)
    clip = "pbcopy";
    paste = "pbpaste";

    # Network
    myip = "curl -s https://api.ipify.org && echo";
    localip = "ipconfig getifaddr en0";
    ips = "ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'";
    weather = "curl wttr.in";

    # ============================================
    # Modern CLI Replacements
    # ============================================
    cat = "bat";
    ls = "eza";
    l = "eza -lagF --icons --git";
    la = "ls -A";
    ll = "eza -lagTL2 -F --icons --git";
    lt = "eza --tree";
    find = "fd";
    grep = "rg";

    # ============================================
    # Editors & Terminal
    # ============================================
    v = "nvim";
    n = "nvim";
    vimdiff = "nvim -d";
    t = "tmux";

    # ============================================
    # Git
    # ============================================
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log";
    gd = "git diff";

    # ============================================
    # Docker & Containers
    # ============================================
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    di = "docker images";

    # ============================================
    # Kubernetes
    # ============================================
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
    kg = "kubectl get";
    kgp = "kubectl get pods";
    kgs = "kubectl get svc";
    kgd = "kubectl get deployments";
    kd = "kubectl describe";
    kaf = "kubectl apply -f";
    kdel = "kubectl delete";
    kl = "kubectl logs";
    klog = "kubectl logs -f";
    ke = "kubectl exec -it";
    kexec = "kubectl exec -it";
    kpf = "kubectl port-forward";

    # ============================================
    # Terraform
    # ============================================
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

    # ============================================
    # Helm
    # ============================================
    h = "helm";
    hi = "helm install";
    hu = "helm upgrade";
    hd = "helm delete";
    hl = "helm list";
    hs = "helm search repo";
    hr = "helm repo";
    hru = "helm repo update";

    # ============================================
    # ArgoCD
    # ============================================
    argo = "argocd";
    argoapp = "argocd app";
    argosync = "argocd app sync";
    argolist = "argocd app list";

    # ============================================
    # AWS & Cloud
    # ============================================
    awsprofile = "export AWS_PROFILE=";
    awswho = "aws sts get-caller-identity";
    awsregion = "export AWS_REGION=";

    # ============================================
    # Ruby & Rails
    # ============================================
    b = "bundle exec";

    # ============================================
    # Nix & Home Manager
    # ============================================
    nix-switch = "home-manager switch --flake ~/.dotfiles";
    nix-update = "nix flake update ~/.dotfiles";

    # ============================================
    # macOS Specific
    # ============================================
    brewup = "brew update && brew upgrade && brew cleanup";
    update = "brew update && brew upgrade && brew cleanup";

    # Finder
    showfiles = "defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder";
    hidefiles = "defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder";

    # System maintenance
    flushdns = "sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder";
    emptytrash = "sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl";
    lscleanup = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder";

    # Quick Look
    ql = "qlmanage -p";

    # ============================================
    # Utilities
    # ============================================
    ff = "fastfetch -c neofetch";
    ffd = "fastfetch -c examples/25";

    # ============================================
    # Node.js compatibility (bun can run Node apps)
    # ============================================
    node = "bun";
    npm = "bun";
    npx = "bunx";
  };
}
