{ config, ... }:
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

      os.editPreset = config.home.sessionVariables.EDITOR;

      customCommands = [
        {
          key = "<c-g>";
          command = "gh pr create --fill --web";
          context = "global";
          loadingText = "Creating pull request on GitHub";
        }
      ];

    };
  };
}
