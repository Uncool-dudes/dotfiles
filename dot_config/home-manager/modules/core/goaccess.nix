{ ... }:
{
  home.file.".goaccessrc".text = ''
    # baseline scheme; explicit color overrides below take priority
    color-scheme 3

    config-dialog false
    hl-header true
    no-color false

    # oxocarbon-derived xterm-256 palette
    color COLOR_MTRC_HITS              color80:color-1
    color COLOR_MTRC_VISITORS          color71:color-1
    color COLOR_MTRC_DATA              color75:color-1
    color COLOR_MTRC_BW                color211:color-1
    color COLOR_MTRC_AVGTS             color141:color-1
    color COLOR_MTRC_CUMTS             color239:color-1
    color COLOR_MTRC_MAXTS             color254:color-1
    color COLOR_MTRC_PROT              color75:color-1
    color COLOR_MTRC_MTHD              color141:color-1
    color COLOR_MTRC_HITS_PERC         color254:color-1
    color COLOR_MTRC_HITS_PERC_MAX     color141:color-1
    color COLOR_MTRC_VISITORS_PERC     color254:color-1
    color COLOR_MTRC_VISITORS_PERC_MAX color141:color-1
    color COLOR_MTRC_BW_PERC           color254:color-1
    color COLOR_MTRC_BW_PERC_MAX       color141:color-1
    color COLOR_PANEL_COLS             color237:color-1
    color COLOR_BARS                   color239:color-1
    color COLOR_SUBBARS                color254:color-1
    color COLOR_CHART_AXIS             color239:color-1
    color COLOR_CHART_VALUES           color254:color-1
    color COLOR_ERROR                  color231:color204
    color COLOR_SELECTED               color231:color75
    color COLOR_PANEL_ACTIVE           color231:color235
    color COLOR_PANEL_HEADER           color254:color235
    color COLOR_PANEL_DESC             color239:color-1
    color COLOR_OVERALL_LBLS           color239:color-1
    color COLOR_OVERALL_VALS           color80:color-1
    color COLOR_OVERALL_PATH           color141:color-1
    color COLOR_ACTIVE_LABEL           color141:color235 bold underline
    color COLOR_BG                     color254:color-1
    color COLOR_DEFAULT                color239:color-1
    color COLOR_PROGRESS               color231:color80
  '';
}
