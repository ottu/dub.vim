if exists("g:loaded_dub_vim_plugin")
    finish
endif
let g:loaded_dub_vim_plugin = 1

let s:V = vital#of('dub_vim')
let s:JSON = s:V.import('Web.JSON')

let result = []
if glob("dub.json") != ""
    let dub_json = s:JSON.decode( system('dub describe') )
    for package in dub_json.packages
        for import_path in package.importPaths
            call add(result, package.path . import_path)
        endfor
    endfor
    let g:syntastic_d_include_dirs = result

    if glob("./views") != ""
        let g:syntastic_d_compiler_options = '-J./views'
    endif
endif
