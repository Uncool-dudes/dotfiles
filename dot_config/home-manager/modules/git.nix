{
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    signing = {
      key = null;
      format = "ssh";
      signByDefault = true;
      signer =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "op-ssh-sign";
    };

    ignores = [ "**/.claude/settings.local.json" ];

    maintenance = {
      enable = true;
      repositories = [
        "${config.home.homeDirectory}/projects/ratch/gamma"
      ];
    };

    includes = [ { path = "~/.config/git/signing.inc"; } ];

    settings = {
      user = {
        name = "Ananth Pullur";
        email = "106897936+Uncool-dudes@users.noreply.github.com";
      };

      core = {
        compression = 6;
        whitespace = "error";
        preloadindex = true;
        fsmonitor = true;
        untrackedCache = true;
        quotePath = false;
        editor = "nvim";
        pager = "delta";
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
        date = "relative";
      };

      format.pretty = "format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";

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

      credential = {
        "https://github.com".helper = [
          ""
          "!gh auth git-credential"
        ];
        "https://gist.github.com".helper = [
          ""
          "!gh auth git-credential"
        ];
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
        co = "checkout";
        s = "status -sb";
        d = "diff";
        staged = "diff --staged";
        last = "show -w HEAD";
        lg = "log --graph --all";
        tree = "log --graph --oneline --all --decorate";
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
        gone = "!git branch -vv | rg --no-line-number ': gone]' | awk '{print $1}' | xargs git branch -D";
        prune-merged = "!git branch --merged | rg -v '\\*|main|master' | xargs -n 1 git branch -d";
        sqa = "!git fetch origin main:main --quiet 2>/dev/null; git rebase -i --autosquash $(git merge-base main HEAD)";
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
      line-numbers = true;
      hyperlinks = true;
      keep-plus-minus-markers = false;
      tabs = 4;
      syntax-theme = "base16-stylix";
      blame-palette = "#161616 #1e1e1e #262626";
      merge-conflict-begin-symbol = "▼";
      merge-conflict-end-symbol = "▲";
      file-modified-label = "Δ";
      right-arrow = "⟶  ";
    };
  };

}
