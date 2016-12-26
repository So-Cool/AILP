#!/usr/bin/env swipl -f -q
/*
 *  ailp.pl
 *
 *  AI and Logic Programming assignment runner.
 *  Loads and runs specified assignmentN_library.pl file from
 *  assignmentN folder.
 */

:- dynamic
     user:prolog_file_type/2,
     user:file_search_path/2.

:- multifile
     user:prolog_file_type/2,
     user:file_search_path/2.

:-  % parse command line arguments
    current_prolog_flag(argv, Args),
    % take first argument to be the name of the assignment folder
    ( Args=['assignment1'|[]] -> Assignment_name='assignment1'
    ; Args=['assignment2','part1'|[]] -> Assignment_name='oscar'
    ; Args=['assignment2','part2'|[]] -> Assignment_name='wp'
    ; Args=['assignment2','part3'|[]] -> Assignment_name='assignment2'
    ; Args=['assignment2','part4'|[]] -> Assignment_name='assignment2'
    ; % missing argument, so display syntax and halt
       nl,
       write('Syntax:'),nl,
       nl,
       write('  ./ailp.pl <assignment_name> [part]'),nl,
       write('e.g. ./ailp.pl assignment1'),nl,
       write('or'),nl,
       write('e.g. ./ailp.pl assignment2 part1'),nl,
       nl,
       halt(1)
    ),
    assert(assignment(Assignment_name)).

:-  % get assignment details
    assignment(Assignment_name),
    atom_concat(Assignment_name, '_library', Assignment_library_name),
    %
    % define a module path assignment_root()
    prolog_load_context(directory, Sys),
    (\+ user:file_search_path(assignment_root, Sys)
    ->  asserta(user:file_search_path(assignment_root, Sys))
    ),
    %
    % define our own ailp path assignment_ailp()
    atom_concat(Sys, '/ailp', Ailp),
    (\+ user:file_search_path(assignment_ailp, Ailp)
    ->  asserta(user:file_search_path(assignment_ailp, Ailp))
    ),
    %
    % define our own Library path assignment_library()
    atom_concat(Ailp, '/library', Lib),
    (\+ user:file_search_path(assignment_library, Lib)
    ->  asserta(user:file_search_path(assignment_library, Lib))
    ),
    %
    % load files
    load_files(
      [ %assignment_ailp(command_channel),
        assignment_library(Assignment_library_name)
      ],
      [ silent(true)
      ]
    ),
    %
    % set up dependencies
    ( Assignment_name='wp' -> (retract(part(1)), assertz(part(2)))
    ; otherwise -> true
    ).
