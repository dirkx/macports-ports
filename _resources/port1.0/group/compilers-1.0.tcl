# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2014 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of The MacPorts Project nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# This PortGroup sets up default variants for projects that want multiple
# compilers for providing options for, example, different optimizations. More
# importantly, this port group provides the ability to interact with packages
# that need MPI since MPI is juat a wrapper around a compiler.
#
# Usage:
#
#   PortGroup               compilers 1.0

PortGroup active_variants 1.1

options compilers.variants compilers.gcc_variants
default compilers.variants {}
default compilers.fortran_variants {}
default compilers.gcc_variants {}
default compilers.clang_variants {}
default compilers.dragonegg_variants {}
default compilers.require_fortran 0
default compilers.setup_done 0
default compilers.required_c {}
default compilers.required_f {}

# also set a default gcc version
set compilers.gcc_default gcc49

set compilers.list {cc cxx cpp objc fc f77 f90}

# build database of gcc {4{4..9} 5 6} compiler attributes
set gcc_versions {44 45 46 47 48 49 5 6}
foreach v ${gcc_versions} {
    # if the string is more than one character insert a '.' into it: e.g 49 -> 4.9
    set version $v
    if {[string length $v] > 1} {
        set version [string index $v 0].[string index $v 1]
    }
    lappend compilers.gcc_variants gcc$v
    set cdb(gcc$v,variant)  gcc$v
    set cdb(gcc$v,compiler) macports-gcc-$version
    set cdb(gcc$v,descrip)  "MacPorts gcc $version"
    set cdb(gcc$v,depends)  port:gcc$v
    set cdb(gcc$v,dependsl) path:lib/libgcc/libgcc_s.1.dylib:libgcc
    set cdb(gcc$v,dependsd) port:g95
    set cdb(gcc$v,dependsa) gcc$v
    set cdb(gcc$v,conflict) "gfortran g95"
    set cdb(gcc$v,cc)       ${prefix}/bin/gcc-mp-$version
    set cdb(gcc$v,cxx)      ${prefix}/bin/g++-mp-$version
    set cdb(gcc$v,cpp)      ${prefix}/bin/cpp-mp-$version
    set cdb(gcc$v,objc)     ${prefix}/bin/gcc-mp-$version
    set cdb(gcc$v,fc)       ${prefix}/bin/gfortran-mp-$version
    set cdb(gcc$v,f77)      ${prefix}/bin/gfortran-mp-$version
    set cdb(gcc$v,f90)      ${prefix}/bin/gfortran-mp-$version
}

set clang_versions {33 34 35}
foreach v ${clang_versions} {
    # if the string is more than one character insert a '.' into it: e.g 33 -> 3.3
    set version $v
    if {[string length $v] > 1} {
        set version [string index $v 0].[string index $v 1]
    }
    lappend compilers.clang_variants clang$v
    set cdb(clang$v,variant)  clang$v
    set cdb(clang$v,compiler) macports-clang-$version
    set cdb(clang$v,descrip)  "MacPorts clang $version"
    set cdb(clang$v,depends)  port:clang-$version
    set cdb(clang$v,dependsl) ""
    set cdb(clang$v,dependsd) ""
    set cdb(clang$v,dependsa) clang-$version
    set cdb(clang$v,conflict) ""
    set cdb(clang$v,cc)       ${prefix}/bin/clang-mp-$version
    set cdb(clang$v,cxx)      ${prefix}/bin/clang++-mp-$version
    set cdb(clang$v,cpp)      "${prefix}/bin/clang-mp-$version -E"
    set cdb(clang$v,objc)     ""
    set cdb(clang$v,fc)       ""
    set cdb(clang$v,f77)      ""
    set cdb(clang$v,f90)      ""
}

# dragonegg versions match the corresponding clang version until 3.5
set dragonegg_versions {3 4}
foreach v ${dragonegg_versions} {
    lappend compilers.dragonegg_variants dragonegg3$v
    set cdb(dragonegg3$v,variant)  dragonegg3$v
    set cdb(dragonegg3$v,compiler) macports-dragonegg-3.$v
    set cdb(dragonegg3$v,descrip)  "MacPorts dragonegg 3.$v"
    set cdb(dragonegg3$v,depends)  path:bin/dragonegg-3.$v-gcc:dragonegg-3.$v
    set cdb(dragonegg3$v,dependsl) path:lib/libgcc/libgcc_s.1.dylib:libgcc
    set cdb(dragonegg3$v,dependsd) port:g95
    set cdb(dragonegg3$v,dependsa) dragonegg-3.$v
    set cdb(dragonegg3$v,conflict) "gfortran g95"
    set cdb(dragonegg3$v,cc)       ${prefix}/bin/dragonegg-3.$v-gcc
    set cdb(dragonegg3$v,cxx)      ${prefix}/bin/dragonegg-3.$v-g++
    set cdb(dragonegg3$v,cpp)      ${prefix}/bin/dragonegg-3.$v-cpp
    set cdb(dragonegg3$v,objc)     ""
    set cdb(dragonegg3$v,fc)       ${prefix}/bin/dragonegg-3.$v-gfortran
    set cdb(dragonegg3$v,f77)      ${prefix}/bin/dragonegg-3.$v-gfortran
    set cdb(dragonegg3$v,f90)      ${prefix}/bin/dragonegg-3.$v-gfortran
}

set cdb(llvm,variant)  llvm
set cdb(llvm,compiler) llvm-gcc-4.2
set cdb(llvm,descrip)  "Apple native llvm-gcc 4.2"
set cdb(llvm,depends)  bin:llvm-gcc-4.2:llvm-gcc42
set cdb(llvm,dependsl) ""
set cdb(llvm,dependsd) ""
set cdb(llvm,dependsa) ""
set cdb(llvm,conflict) ""
set cdb(llvm,cc)       llvm-gcc-4.2
set cdb(llvm,cxx)      llvm-g++-4.2
set cdb(llvm,cpp)      llvm-cpp-4.2
set cdb(llvm,objc)     llvm-gcc-4.2
set cdb(llvm,fc)       ""
set cdb(llvm,f77)      ""
set cdb(llvm,f90)      ""

# and lastly we add a gfortran and g95 variant for use with clang* and llvm; note that
# we don't need gfortran when we are in an "only-fortran" mode
set cdb(gfortran,variant)  gfortran
set cdb(gfortran,compiler) gfortran
set cdb(gfortran,descrip)  "Fortran compiler from gcc49"
set cdb(gfortran,depends)  $cdb(${compilers.gcc_default},depends)
set cdb(gfortran,dependsl) $cdb(${compilers.gcc_default},dependsl)
set cdb(gfortran,dependsd) $cdb(${compilers.gcc_default},dependsd)
set cdb(gfortran,dependsa) $cdb(${compilers.gcc_default},dependsa)
set cdb(gfortran,conflict) $cdb(${compilers.gcc_default},conflict)
set cdb(gfortran,cc)       ""
set cdb(gfortran,cxx)      ""
set cdb(gfortran,cpp)      ""
set cdb(gfortran,objc)     ""
set cdb(gfortran,fc)       $cdb(${compilers.gcc_default},fc)
set cdb(gfortran,f77)      $cdb(${compilers.gcc_default},f77)
set cdb(gfortran,f90)      $cdb(${compilers.gcc_default},f90)

set cdb(g95,variant)  g95
set cdb(g95,compiler) g95
set cdb(g95,descrip)  "g95 Fortran"
set cdb(g95,depends)  port:g95
set cdb(g95,dependsl) ""
set cdb(g95,dependsd) ""
set cdb(g95,dependsa) g95
set cdb(g95,conflict) ""
set cdb(g95,cc)       ""
set cdb(g95,cxx)      ""
set cdb(g95,cpp)      ""
set cdb(g95,objc)     ""
set cdb(g95,fc)       ${prefix}/bin/g95
set cdb(g95,f77)      ${prefix}/bin/g95
set cdb(g95,f90)      ${prefix}/bin/g95

foreach cname [array names cdb *,variant] {
    lappend compilers.variants $cdb($cname)
}

foreach variant ${compilers.variants} {
    if {$cdb($variant,f77) ne ""} {
        lappend compilers.fortran_variants $variant
    }
}

proc compilers.setup_variants {args} {
    global cdb compilers.variants compilers.clang_variants compilers.gcc_variants
    global compilers.dragonegg_variants compilers.fortran_variants compilers.list

    foreach variant [split $args] {
        if {$cdb($variant,f77) ne ""} {
            lappend compilers.fortran_variants $variant
        }

        if {[variant_exists $variant]} {
            ui_debug "$variant variant already exists, so not adding the default one"
        } else {
            set i [lsearch -exact ${compilers.variants} $variant]
            set c [lreplace ${compilers.variants} $i $i]

            # Fortran compilers do not conflict with C compilers.
            # thus, llvm and clang do not conflict with g95 and gfortran
            if {$variant eq "gfortran" || $variant eq "g95"} {
                foreach clangcomp [concat ${compilers.clang_variants} {llvm}] {
                    set i [lsearch -exact $c $clangcomp]
                    set c [lreplace $c $i $i]
                }
            } elseif {[string match clang* $variant] || $variant == "llvm"} {
                set i [lsearch -exact $c gfortran]
                set c [lreplace $c $i $i]
                set i [lsearch -exact $c g95]
                set c [lreplace $c $i $i]
            }

            # only add conflicts from the compiler database (set above) if we
            # actually have the compiler in the list of allowed variants
            foreach j $cdb($variant,conflict) {
                if {[lsearch -exact $j ${compilers.variants}] > -1} {
                    lappend c $j
                }
            }

            # for each compiler, set the value if not empty; we can't use
            # configure.compiler because of dragonegg and possibly other new
            # compilers that aren't in macports portconfigure.tcl
            set comp ""
            foreach compiler ${compilers.list} {
                if {$cdb($variant,$compiler) ne ""} {
                    append comp [subst {
                        configure.$compiler $cdb($variant,$compiler)

                        # disable archflags
                        if {"[info command configure.${compiler}_archflags]" ne ""} {
                            configure.${compiler}_archflags
                            configure.ld_archflags
                        }
                    }]
                }
            }

            eval [subst {
                variant ${variant} description \
                    {Build using the $cdb($variant,descrip) compiler} \
                    conflicts $c {

                    depends_build-append   $cdb($variant,depends)
                    depends_lib-append     $cdb($variant,dependsl)
                    depends_lib-delete     $cdb($variant,dependsd)
                    depends_skip_archcheck $cdb($variant,dependsa)

                    $comp
                }
            }]
        }
    }
}

foreach variant ${compilers.gcc_variants} {
    # we need to check the default_variants so we can't use variant_isset
    if {[info exists variations($variant)] && $variations($variant) eq "+"} {
        depends_lib-delete      port:g95
        break
    }
}

proc c_active_variant_name {depspec} {
    global compilers.variants compilers.fortran_variants
    set c_list [remove_from_list ${compilers.variants} {gfortran g95}]

    foreach c $c_list {
        if {![catch {set result [active_variants $depspec $c ""]}]} {
            if {$result} {
                return $c
            }
        }
    }

    return ""
}

proc c_variant_name {} {
    global compilers.variants compilers.fortran_variants
    set c_list [remove_from_list ${compilers.variants} {gfortran g95}]

    foreach cc $c_list {
        if {[variant_isset $cc]} {
            return $cc
        }
    }

    return ""
}

proc fortran_active_variant_name {depspec} {
    global compilers.fortran_variants

    foreach fc ${compilers.fortran_variants} {
        if {![catch {set result [active_variants $depspec $fc ""]}]} {
            if {$result} {
                return $fc
            }
        }
    }

    return ""
}

proc fortran_variant_name {} {
    global compilers.fortran_variants variations

    foreach fc ${compilers.fortran_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($fc)] && $variations($fc) eq "+"} {
            return $fc
        }
    }

    return ""
}

proc clang_variant_name {} {
    global compilers.clang_variants compilers.dragonegg_variants variations

    foreach c ${compilers.clang_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($c)] && $variations($c) eq "+"} {
            return $c
        }
    }

    foreach c ${compilers.dragonegg_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($c)] && $variations($c) eq "+"} {
            return $c
        }
    }

    return ""
}

proc clang_variant_isset {} {
    return [expr {[clang_variant_name] ne ""}]
}

proc gcc_variant_name {} {
    global compilers.gcc_variants variations

    foreach c ${compilers.gcc_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($c)] && $variations($c) eq "+"} {
            return $c
        }
    }

    return ""
}

proc gcc_variant_isset {} {
    return [expr {[gcc_variant_name] ne ""}]
}

proc avx_compiler_isset {} {
    global configure.cc

    set cc ${configure.cc}

    # check for mpi
    if {[string match *mpi* $cc]} {
        set cc [exec ${configure.cc} -show]
    }

    if {[string match *clang* $cc]} {
        return 1
    }

    return 0
}

proc fortran_variant_isset {} {
    return [expr {[fortran_variant_name] ne ""}]
}

# remove all elements in R from L
proc remove_from_list {L R} {
    foreach e $R {
        set idx [lsearch $L $e]
        set L [lreplace $L $idx $idx]
    }
    return $L
}

# add all elements in R from L
proc add_from_list {L A} {
    return [concat $L $A]
}

proc compilers.choose {args} {
    global compilers.list

    # zero out the variable before and append args
    set compilers.list {}
    foreach v $args {
        lappend compilers.list $v
    }
}

proc compilers.is_fortran_only {} {
    global compilers.list

    foreach c {cc cxx cpp objc} {
        if {[lsearch -exact ${compilers.list} $c] >= 0} {
            return 0
        }
    }

    return 1
}

proc compilers.is_c_only {} {
    global compilers.list

    foreach c {f77 f90 fc} {
        if {[lsearch -exact ${compilers.list} $c] >= 0} {
            return 0
        }
    }

    return 1
}

# for the c compiler
proc compilers.enforce_c {args} {
    global compilers.required_c
    lappend compilers.required_c $args
}

proc compilers.action_enforce_c {args} {
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otcomp  [c_active_variant_name $portname]
            set mycomp  [c_variant_name]

            if {$otcomp ne "" && $mycomp eq ""} {
                default_variants +$otcomp
            } elseif {$otcomp ne $mycomp} {
                ui_error "Install $portname +$mycomp"
                return -code error "$portname +$mycomp not installed"
            }
        }
    }
}

proc compilers.enforce_fortran {args} {
    global compilers.required_f
    lappend compilers.required_f $args
}

proc compilers.action_enforce_f {args} {
    global compilers.gcc_default
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otf  [fortran_active_variant_name $portname]
            set myf  [fortran_variant_name]

            # gfortran is nothing more than the fortran compiler from a default version of gcc
            set equiv 0
            if {($otf eq ${compilers.gcc_default} || $otf eq "gfortran") &&
                ($myf eq ${compilers.gcc_default} || $myf eq "gfortran")} {
                set equiv 1
            }

            if {$otf ne "" && $myf eq ""} {
                default_variants +$otf
            } elseif {$otf ne $myf && !$equiv} {
                ui_error "Install $portname +$myf"
                return -code error "$portname +$myf not installed"
            }
        }
    }
}

proc compilers.setup {args} {
    global cdb compilers.variants compilers.clang_variants compilers.gcc_variants
    global compilers.dragonegg_variants compilers.fortran_variants
    global compilers.require_fortran compilers.setup_done compilers.list
    global compiler.blacklist

    if {!${compilers.setup_done}} {
        set add_list {}
        set remove_list ${compilers.variants}

        # if we are only setting fortran compilers, then we are in "only fortran
        # mode", i.e. we just need +gccXY and +dragoneggXY for the fortran
        # compilers so we remove +clangXY and +llvm
        if {[compilers.is_fortran_only]} {
            # remove gfortran since that only exists to "complete" clang/llvm
            set remove_list [remove_from_list ${compilers.fortran_variants} gfortran]
        } elseif {[compilers.is_c_only]} {
            # remove gfortran and g95 since those are purely for fortran
            set remove_list [remove_from_list ${compilers.variants} {gfortran g95}]
        }

        foreach v $args {
            # if any negated compiler (e.g. -gcc47) is specified then we are
            # removing from the default, complete list
            set mode add
            if {[string first - $v] == 0} {
                set mode remove

                #strip the beginning '-' character
                set v [string range $v 1 end]
            }

            # handle special cases, such as 'gcc' -> all gcc variants
            switch -exact $v {
                gcc {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] ${compilers.gcc_variants}]
                }
                dragonegg {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] ${compilers.dragonegg_variants}]
                }
                fortran {
                    # here we just check gfortran and g95, not every fortran
                    # compatible variant since it makes more sense to specify
                    # 'fortran' to mean add just the +gfortran and +g95 variants
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] {gfortran g95}]

                }
                clang {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] ${compilers.clang_variants}]
                }
                require_fortran {
                    # this signals that fortran is required and not optional
                    set compilers.require_fortran 1
                }
                default {
                    if {[info exists cdb($v,variant)] == 0} {
                        return -code error "no such compiler: $v"
                    }
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] $cdb($v,variant)]
                }
            }
        }

        # also remove compilers blacklisted
        foreach compiler ${compiler.blacklist} {
            set matched no
            foreach variant ${compilers.variants} {
                if {[string match $compiler $cdb($variant,compiler)]} {
                    set matched yes
                    set remove_list [remove_from_list $remove_list $cdb($variant,variant)]
                }
            }

            if {!$matched} {
                ui_debug "Unmatched blacklisted compiler: $compiler"
            }
        }

        # remove duplicates
        set duplicates {}
        foreach foo $remove_list {
            if {[lsearch $add_list $foo] != -1} {
                lappend duplicates $foo
            }
        }

        set compilers.variants [lsort [concat [remove_from_list $remove_list $duplicates] $add_list]]
        eval compilers.setup_variants ${compilers.variants}

        if {${compilers.require_fortran} && ![fortran_variant_isset]} {
            if {[lsearch -exact ${compilers.variants} gfortran] > -1} {
                default_variants-append +gfortran
            } elseif {[lsearch -exact ${compilers.variants} gcc49] > -1} {
                default_variants-append +gcc49
            } elseif {[lsearch -exact ${compilers.variants} gcc48] > -1} {
                default_variants-append +gcc48
            } elseif {[lsearch -exact ${compilers.variants} gcc47] > -1} {
                default_variants-append +gcc47
            } elseif {[lsearch -exact ${compilers.variants} gcc46] > -1} {
                default_variants-append +gcc46
            } elseif {[lsearch -exact ${compilers.variants} gcc45] > -1} {
                default_variants-append +gcc45
            } elseif {[lsearch -exact ${compilers.variants} gcc44] > -1} {
                default_variants-append +gcc44
            } elseif {[lsearch -exact ${compilers.variants} g95] > -1} {
                default_variants-append +g95
            }
        }

        set compilers.setup_done 1
    }
}

# this might also need to be in pre-archivefetch
pre-fetch {
    if {${compilers.require_fortran} && [fortran_variant_name] eq ""} {
        return -code error "must set at least one fortran variant"
    }
    eval compilers.action_enforce_c ${compilers.required_c}
    eval compilers.action_enforce_f ${compilers.required_f}
}
