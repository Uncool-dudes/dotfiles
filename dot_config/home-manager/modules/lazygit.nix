{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      disableStartupPopups = true;

      gui = {
        screenMode = "half";
        skipAmendWarning = true;
        skipStashWarning = true;
        skipNoStagedFilesWarning = true;
        showNumstatInFilesView = false;
        showRandomTip = false;
        showDivergenceFromBaseBranch = "arrowAndNumber";
        showIcons = false;
        filterMode = "fuzzy";
        authorLength = 8;
        border = "single";
        animateExplosion = false;
        showBottomLine = false;
        statusPanelStyle = "compact";
        commitLength.show = false;
        expandFocusedSidePanel = true;
        expandedSidePanelWeight = 20;
        scrollOffMargin = 5;
      };

      git = {
        overrideGpg = true;
        diffRenderers = [
          {
            command = "delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
            colorArg = "always";
          }
        ];
        autoForwardBranches = "allBranches";
        parseEmoji = false;
      };

      os.editPreset = "nvim";

      customCommands = [
        {
          key = "<c-g>";
          command = "gh pr create --fill --web";
          context = "global";
          loadingText = "Creating pull request on GitHub";
        }
        {
          key = "b";
          command = ''tig blame -- "{{.SelectedFile.Name}}"'';
          context = "files";
          description = "blame file at tree";
          output = "terminal";
        }
        {
          key = "b";
          command = ''tig blame {{.SelectedSubCommit.Sha}} -- "{{.SelectedCommitFile.Name}}"'';
          context = "commitFiles";
          description = "blame file at revision";
          output = "terminal";
        }
        {
          key = "B";
          command = ''tig blame -- "{{.SelectedCommitFile.Name}}"'';
          context = "commitFiles";
          description = "blame file at tree";
          output = "terminal";
        }
        {
          key = "t";
          command = "tig show {{.SelectedSubCommit.Sha}}";
          context = "subCommits";
          description = "tig commit";
          output = "terminal";
        }
        {
          key = "t";
          command = "tig show {{.SelectedLocalBranch.Name}}";
          context = "localBranches";
          description = "tig branch";
          output = "terminal";
        }
        {
          key = "t";
          command = "tig show {{.SelectedRemoteBranch.RemoteName}}/{{.SelectedRemoteBranch.Name}}";
          context = "remoteBranches";
          description = "tig branch";
          output = "terminal";
        }
        {
          key = "t";
          command = ''tig {{.SelectedSubCommit.Sha}} -- "{{.SelectedCommitFile.Name}}"'';
          context = "commitFiles";
          description = "tig file history";
          output = "terminal";
        }
        {
          key = "t";
          command = ''tig -- "{{.SelectedFile.Name}}"'';
          context = "files";
          description = "tig file history";
          output = "terminal";
        }
      ];

    };
  };
}
