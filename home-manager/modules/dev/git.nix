{
  config,
  pkgs,
  ...
}:
let
  email = "106897936+Uncool-dudes@users.noreply.github.com";
  # Public half of the SSH key 1Password signs with - not a secret, so it
  # lives here instead of behind an onepasswordRead that needs Touch ID.
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUxgXsXOayn+GQZz8Q5rWmKZpGo0TsdhSd7xA4PXkaD";
in
{
  xdg.configFile."git/allowed_signers".text = "${email} ${signingKey}\n";

  programs.git = {
    enable = true;

    attributes = [
      "*.go merge=mergiraf"
      "go.mod merge=mergiraf"
      "go.sum merge=mergiraf"
      "*.json merge=mergiraf"
      "*.yaml merge=mergiraf"
      "*.yml merge=mergiraf"
      "*.toml merge=mergiraf"
    ];

    signing = {
      key = signingKey;
      format = "ssh";
      signByDefault = true;
      signer =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "op-ssh-sign";
    };

    ignores = [ "**/.claude/settings.local.json" ];

    # Only the launchd schedule lives here. The repo list is machine state:
    # the ghq wrapper in zsh/extra.zsh registers every ghq repo into
    # maintenance.inc, since `git maintenance register` can't write to this
    # read-only store-backed config.
    maintenance.enable = true;

    includes = [ { path = "~/.config/git/maintenance.inc"; } ];

    settings = {
      user = {
        name = "Ananth Pullur";
        inherit email;
      };

      feature.manyFiles = true;

      core = {
        compression = 6;
        whitespace = "error";
        preloadindex = true;
        fsmonitor = false;
        untrackedCache = true;
        quotePath = false;
        editor = config.home.sessionVariables.EDITOR;
        pager = "delta";
        abbrev = 12;
      };

      init.defaultBranch = "main";

      advice = {
        addEmptyPathspec = false;
        pushNonFastForward = false;
        statusHints = false;
      };

      help.autocorrect = "prompt";
      color.ui = "auto";
      commit.verbose = true;

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = true;
      };

      log = {
        abbrevCommit = true;
        decorate = true;
        date = "format:%Y-%m-%d %H:%M";
        follow = true;
        diffMerges = "first-parent";
        excludeDecoration = "refs/remotes/origin/HEAD";
      };

      format.pretty = "format:%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)%n";

      pretty.compact = "format:%C(auto)%h%d %s %C(dim)(%an, %ad)%Creset";

      branch.sort = "-committerdate";
      column.ui = "auto";
      tag.sort = "-version:refname";

      submodule = {
        recurse = true;
        fetchJobs = 4;
      };

      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
        algorithm = "histogram";
        colorMoved = "dimmed-zebra";
        colorMovedWS = "allow-indentation-change";
        mnemonicPrefix = true;
        wsErrorHighlight = "all";
        submodule = "log";
        tool = "nvimdiff";
        guitool = "meld";
      };

      merge = {
        conflictStyle = "zdiff3";
        log = 20;
        autoStash = true;
        tool = "nvimdiff";
        guitool = "meld";
      };

      "merge \"mergiraf\"" = {
        name = "mergiraf merge driver";
        driver = "${pkgs.mergiraf}/bin/mergiraf merge --git -s %S -x %X -y %Y -p %P -l %L %O %A %B";
      };

      difftool = {
        prompt = false;
        "nvimdiff".cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      };

      mergetool = {
        prompt = false;
        keepBackup = false;
        "nvimdiff".cmd = ''nvim -d "$LOCAL" "$MERGED" "$REMOTE"'';
      };

      push = {
        autoSetupRemote = true;
        useForceIfIncludes = true;
        default = "current";
        followTags = true;
        recurseSubmodules = "on-demand";
      };

      fetch = {
        prune = true;
        pruneTags = true;
        fsckObjects = true;
        recurseSubmodules = "on-demand";
        writeCommitGraph = true;
        showForcedUpdates = true;
        output = "compact";
      };

      pull.rebase = true;

      rebase = {
        abbreviateCommands = true;
        autoStash = true;
        autoSquash = true;
        forkPoint = true;
        missingCommitsCheck = "warn";
        updateRefs = true;
        rescheduleFailedExec = true;
        instructionFormat = "%s%n# %an, %ar";
      };

      rerere = {
        enabled = true;
        autoUpdate = true;
      };

      stash = {
        index = true;
        showPatch = true;
      };

      grep = {
        lineNumber = true;
        extendedRegexp = true;
      };

      transfer.fsckObjects = true;
      receive.fsckObjects = true;
      interactive.singlekey = true;

      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
        "git@github.com:Uncool-dudes/" = {
          insteadOf = "uc:";
        };
      };

      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";

      pager = {
        diff = "delta";
        blame = "delta --features=blame";
        log = "delta --features=log";
      };

      interactive.diffFilter = "delta --color-only";

      delta = {
        blame.side-by-side = false;
        log.side-by-side = false;
      };

      alias = {
        ec = "config --global --edit";
        a = "add -A";
        ap = "add -p";
        c = "commit";
        cm = "commit -m";
        amend = "commit --amend --no-edit";
        reword = "commit --amend";
        b = "branch";
        ba = "branch -a";
        sw = "switch";
        swc = "switch -c";
        s = "status -sb";
        d = "diff";
        staged = "diff --staged";
        last = "show -w HEAD";
        lg = "log --graph --all";
        lgc = "log --graph --all --pretty=compact";
        main-line = "log --first-parent --oneline";
        what-changed = "log --ancestry-path --oneline --no-merges";
        who = "shortlog -sn --no-merges";
        f = "fetch --all";
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull --rebase";
        ss = "stash";
        sp = "stash pop";
        sl = "stash list";
        undo = "reset HEAD~1 --soft";
        nuke = "reset --hard HEAD";
        unstage = "restore --staged";
        sub = "submodule update --remote --rebase";
        base = "!git fetch origin main:main --quiet 2>/dev/null; git merge-base main HEAD";
        fixup = "!f() { git commit --fixup=\"\${1:-HEAD}\"; }; f";
        rc = "rebase --continue";
        ra = "rebase --abort";
        rs = "rebase --skip";
      };
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      side-by-side = false;
      line-numbers = false;
      hyperlinks = true;
      keep-plus-minus-markers = false;
      tabs = 4;
      syntax-theme = "base16-stylix";
      blame-palette = "#161616 #1e1e1e #262626";
      merge-conflict-begin-symbol = "▼";
      merge-conflict-end-symbol = "▲";
      file-modified-label = "Δ";
      right-arrow = "⟶  ";
      file-decoration-style = "none";
      commit-decoration-style = "none";
      hunk-header-style = "omit";
      hunk-header-decoration-style = "none";
      zero-style = "dim syntax";
      plus-style = "syntax";
      minus-style = "syntax";
      whitespace-error-style = "";
      width = "variable";
    };
  };

}
