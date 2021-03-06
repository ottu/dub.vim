if exists("g:loaded_dub_vim_plugin")
    finish
endif
let g:loaded_dub_vim_plugin = 1

let s:V = vital#of('dub_vim')
let s:JSON = s:V.import('Web.JSON')

" convert from /path/to/dub/dir to [ 'path', 'to', 'dub', 'dir' ]
let parents = split( getcwd(), '/' )

" get parent paths
" [ '/path',
"   '/path/to',
"   '/path/to/dub',
"   '/path/to/dub/dir' ]
let search_paths = []
for parent in parents
    if len(search_paths) == 0
        call add( search_paths, '/' . parent )
    else
        call add( search_paths, search_paths[-1] . '/' . parent)
    endif
endfor

" reverse parent paths, because shorter index is neary current directory.
" [ '/path/to/dub/dir',
"   '/path/to/dub',
"   '/path/to',
"   '/path', ]
call reverse(search_paths)

for search_path in search_paths

    " /path/to/dub/dir/dub.json
    let dub_json_path = search_path . "/dub.json"
    if glob(dub_json_path) == ""
        continue
    endif

    " It must execute 'dub describe' with the location of dub.json .
    cd `=search_path`

    let import_paths = []
    let string_import_paths = []
    let dub_json = s:JSON.decode( system('dub describe') )
    for package in dub_json.packages
        for import_path in package.importPaths
            call add(import_paths, package.path . import_path)
        endfor

        for string_import_path in package.stringImportPaths
            let check_path = package.path . string_import_path
            if glob(check_path) != ""
                call add(string_import_paths, "-J" . check_path)
            endif
        endfor
    endfor

    let g:syntastic_d_include_dirs = import_paths
    let g:syntastic_d_compiler_options = join(string_import_paths, " ")

    " return before directory.
    cd -
    break
endfor


