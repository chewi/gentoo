project('dwarf-fortress', 'cpp', default_options : ['cpp_std=c++20'])

minizip = dependency('minizip')

shared_library(
    'g_src_lib',
    sources : %SOURCES%,
    cpp_args : [
        '-DCUSTOM_SOUND_PLUGINS'
    ],
    dependencies : [
        minizip
    ]
)
