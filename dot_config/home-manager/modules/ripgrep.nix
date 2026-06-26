{ ... }:
{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--follow"
      "--line-number"
      "--max-columns=200"
      "--max-columns-preview"
      "--max-filesize=2M"
      "--glob=!go.sum"
      "--glob=!*.map"
      "--glob=!*.min.js"
      "--glob=!*.min.css"
      "--type-add=go-tmpl:*.tmpl"
      "--type-add=svelte:*.svelte"
      "--type-add=proto:*.proto"
      "--colors=match:fg:yellow"
      "--colors=match:style:bold"
      "--colors=path:fg:cyan"
      "--colors=line:fg:green"
      "--heading"
    ];
  };
}
