---@brief
---
--- https://github.com/ocaml/ocaml-lsp
---
--- `ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).
---
--- To install the lsp server in a particular opam switch:
--- ```sh
--- opam install ocaml-lsp-server
--- ```

local switch_prefix = os.getenv('OPAM_SWITCH_PREFIX')
local ocamllsp_cmd = ''
if switch_prefix then
  ocamllsp_cmd = switch_prefix .. '/bin/ocamllsp'
else
  ocamllsp_cmd = 'ocamllsp'
end

return {
  cmd = { ocamllsp_cmd },
  filetypes = {
    'ocaml',
    'ocaml.menhir',
    'ocaml.interface',
    'ocaml.ocamllex',
    'reason',
    'dune',
  },
  root_markers = {
    { 'dune-project', 'dune-workspace' },
    { '*.opam', 'esy.json', 'package.json' },
    '.git',
  },
  settings = {},
}
