{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        screenMode = "half";
        skipAmendWarning = true;
        skipStashWarning = true;
        skipNoStagedFilesWarning = true;
        showNumstatInFilesView = true;
        showRandomTip = false;
        showDivergenceFromBaseBranch = "arrowAndNumber";
        nerdFontsVersion = "3";
        filterMode = "fuzzy";
        border = "hidden";
        animateExplosion = true;
        theme = {
          activeBorderColor = [ "#be95ff" "bold" ];
          inactiveBorderColor = [ "#525252" ];
          searchingActiveBorderColor = [ "#3ddbd9" "bold" ];
          optionsTextColor = [ "#78a9ff" ];
          selectedLineBgColor = [ "#393939" ];
          inactiveViewSelectedLineBgColor = [ "#262626" ];
          cherryPickedCommitFgColor = [ "#ff7eb6" ];
          cherryPickedCommitBgColor = [ "#262626" ];
          markedBaseCommitFgColor = [ "#161616" ];
          markedBaseCommitBgColor = [ "#be95ff" ];
          unstagedChangesColor = [ "#ee5396" ];
          defaultFgColor = [ "#f2f4f8" ];
        };
      };

      git = {
        pagers = [
          { pager = "delta --paging=never"; colorArg = "always"; }
        ];
        autoForwardBranches = "allBranches";
        diffContextSize = 5;
        parseEmoji = true;
      };

      os.editPreset = "nvim";

      customCommands = [
        {
          key = "c";
          context = "files";
          description = "convco commit";
          command = "convco commit";
          output = "terminal";
        }
        {
          key = "C";
          context = "files";
          description = "convco commit --amend";
          command = "convco commit --amend";
          output = "terminal";
        }
        {
          key = "Y";
          context = "global";
          description = "Git Town sYnc";
          command = "git town sync --all";
          stream = true;
          loadingText = "Syncing";
        }
        {
          key = "U";
          context = "global";
          description = "Git Town Undo";
          command = "git-town undo";
          prompts = [
            {
              type = "confirm";
              title = "Undo Last Command";
              body = "Are you sure you want to Undo the last Git Town command?";
            }
          ];
          stream = true;
          loadingText = "Undoing Git Town Command";
        }
        {
          key = "!";
          context = "global";
          description = "Git Town Repo (opens the repo link)";
          command = "git-town repo";
          stream = true;
          loadingText = "Opening Repo Link";
        }
        {
          key = "a";
          context = "localBranches";
          description = "Git Town Append";
          prompts = [
            {
              type = "input";
              title = "Enter name of new child branch. Branches off of '{{.CheckedOutBranch.Name}}'";
              key = "BranchName";
            }
          ];
          command = "git-town append {{.Form.BranchName}}";
          stream = true;
          loadingText = "Appending";
        }
        {
          key = "h";
          context = "localBranches";
          description = "Git Town Hack (creates a new branch)";
          prompts = [
            {
              type = "input";
              title = "Enter name of new branch. Branches off of 'Main'";
              key = "BranchName";
            }
          ];
          command = "git-town hack {{.Form.BranchName}}";
          stream = true;
          loadingText = "Hacking";
        }
        {
          key = "K";
          context = "localBranches";
          description = "Git Town Delete";
          command = "git-town delete";
          prompts = [
            {
              type = "confirm";
              title = "Delete current feature branch";
              body = "Are you sure you want to delete the current feature branch?";
            }
          ];
          stream = true;
          loadingText = "Deleting Feature Branch";
        }
        {
          key = "p";
          context = "localBranches";
          description = "Git Town Propose (creates a pull request)";
          command = "git-town propose";
          stream = true;
          loadingText = "Creating pull request";
        }
        {
          key = "P";
          context = "localBranches";
          description = "Git Town Prepend";
          prompts = [
            {
              type = "input";
              title = "Enter name of the branch to insert between '{{.CheckedOutBranch.Name}}' and its parent";
              key = "BranchName";
            }
          ];
          command = "git-town prepend {{.Form.BranchName}}";
          stream = true;
          loadingText = "Prepending";
        }
        {
          key = "S";
          context = "localBranches";
          description = "Git Town Skip";
          command = "git-town skip";
          stream = true;
          loadingText = "Skipping";
        }
        {
          key = "G";
          context = "files";
          description = "Git Town continue (after resolving merge conflicts)";
          command = "git-town continue";
          stream = true;
          loadingText = "Continuing";
        }
      ];
    };
  };
}
