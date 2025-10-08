# User Information

User information is centralized via the `userInfo` module. Set your info directly in host configurations - **no sensitive data in git!**

## Structure

```
user-info/
├── module.nix              # Module definition (committed)
├── personal.nix.example    # Template (committed)
└── work.nix.example        # Template (committed)
```

## Setup

### Configure in Host Files

Set your user information directly in each host configuration:

```nix
# home-manager/hosts/LFX001.nix
{
  userInfo = {
    fullName = "Your Name";
    email = "you@example.com";
    githubUser = "yourusername";
    gitSigningKey = "ssh-ed25519 AAAA...";
  };
}
```

**Personal Machine:**
```nix
# home-manager/hosts/macbook-personal.nix
{
  userInfo = {
    fullName = "Levi Figueira";
    email = "me@levifig.com";
    githubUser = "levifig";
    gitSigningKey = "ssh-ed25519 AAAA...";
  };
}
```

**Work Machine:**
```nix
# home-manager/hosts/macbook-work.nix
{
  userInfo = {
    fullName = "Levi Figueira";
    email = "levi@company.com";
    githubUser = "levi-at-company";
    gitSigningKey = "ssh-ed25519 BBBB...";  # Work key
  };
}
```

## Available Fields

```nix
userInfo = {
  fullName = "Your Full Name";          # Used in git commits, etc.
  email = "your.email@example.com";     # Primary email
  githubUser = "yourusername";           # GitHub username
  gitSigningKey = "ssh-ed25519 AAAA..."; # SSH signing key
};
```

## Why This Approach?

✅ **No sensitive data in git** - User info lives in host configs (which ARE in git but can be public)
✅ **Flexible per-host** - Different email/keys for work vs personal
✅ **Centralized defaults** - Module provides fallback values
✅ **Type-safe** - Nix validates all fields

## Multiple Identities Per Machine

Use git conditional includes for directory-based identity switching:

```nix
# In your host config
programs.git.includes = [
  {
    condition = "gitdir:~/Work/";
    contents = {
      user.email = "levi@company.com";
      user.signingKey = "ssh-ed25519 BBBB...";
    };
  }
  {
    condition = "gitdir:~/OSS/";
    contents = {
      user.email = "opensource@levifig.com";
      user.signingKey = "ssh-ed25519 CCCC...";
    };
  }
];
```

## Bootstrap New Machine

When setting up a new machine:

1. Clone dotfiles
2. Edit `home-manager/hosts/your-machine.nix`
3. Add your `userInfo` block
4. `nix run .#switch`

Your info is in git but easy to modify per-host!
