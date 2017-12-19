#   Copyright 2005-2006 Log4Delphi Project
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#---------------------
# PROJECT PROPERTIES
#---------------------

#
# Compiler properties
#
CC = dcc32
DELPHI.VERSION=5
DELPHI.PACKAGE=STD

#
# Basic properties
#
project.name = @name@
project.title = @title@
project.title.full = @full@
project.version = @version@
test.failonerror = @failonerror@

#
# Source directories
#
source.conf = @conf@
source.delphi = @delphi@
source.test = @test@
source.db = @db@

#
# Build directories
#
build.home = @build@
build.conf = @build-conf@
build.tests = @build-tests@
build.docs = @build-docs@
build.api = @build-api@

#
# Distribution properties
#
build.dist.bin = ${build.home}\bin
build.dist.bin.work = ${build.dist.bin}\${project.name}-${project.version}
build.dist.src = ${build.home}\src
build.dist.src.work = ${build.dist.src}\${project.name}-${project.version}


#-----------------------
# PROJECT BUILD TARGETS
#-----------------------

#
# Default target simply calls the distribution target.
#
all : dist

#
# Clean the build directory.
#
clean :
	if exist ${build.home} rmdir /Q/S ${build.home}
	
#
# Create the build directory.
#
init : clean
	mkdir ${build.home}
	
#
# Compile the delphi package.
#
compile : init
	cd ${source.delphi}
	${CC} ${project.name}_D${DELPHI.VERSION}_${DELPHI.PACKAGE}.dpk
	cd ../../
	
#
# Compile the unit tests.
#
compile_tests : compile
	cd ${source.test}
	${CC} test${project.name}.dpr
	cd ../../
	
#
# Perform the unit tests.
#
test : compile_tests
	copy ${source.db}\* ${build.home}
	${build.home}/test${project.name}.exe -t
	
#
# Generate the api documentation and HTML docs.
#
doc : api site
	xcopy /Y/E ${build.home}\site ${build.docs}

#
# Generate the API.
#
api :
	bin/DCTD_cmd.exe src/docs.dcd

#
# Generate the HTML docs.
#
site :
	FORREST
	
#
# Create distribution folders in the build directory.
#
dist : test doc dist_bin dist_src
	
#
# Create the binary distribution.
#
dist_bin :
	mkdir ${build.dist.bin.work}
	mkdir ${build.dist.bin.work}\bin
	copy /Y LICENSE.txt ${build.dist.bin.work}
	copy /Y README.txt ${build.dist.bin.work}
	copy /Y NOTICE.txt ${build.dist.bin.work}
	copy /Y ${build.home}\*.bpl ${build.dist.bin.work}\bin 
	copy /Y ${build.home}\*.dcu ${build.dist.bin.work}\bin
	del /Q ${build.dist.bin.work}\bin\*Test*.dcu
	mkdir ${build.dist.bin.work}\docs
	xcopy /Y/E ${build.home}\docs ${build.dist.bin.work}\docs
	mkdir ${build.dist.bin.work}\example
	xcopy /Y/E .\example ${build.dist.bin.work}\example
	
#
# Create the source distribution.
#
dist_src :
	mkdir ${build.dist.src.work}
	copy /Y LICENSE.txt ${build.dist.src.work}
	copy /Y README.txt ${build.dist.src.work}
	copy /Y NOTICE.txt ${build.dist.src.work}
	copy /Y build.xml ${build.dist.src.work}
	copy /Y forrest.properties ${build.dist.src.work}
	copy /Y MAKEFILE ${build.dist.src.work}
	mkdir ${build.dist.src.work}\bin
	xcopy /Y/E bin ${build.dist.src.work}\bin
	mkdir ${build.dist.src.work}\src
	xcopy /Y/E src ${build.dist.src.work}\src
	mkdir ${build.dist.src.work}\lib
	xcopy /Y/E lib ${build.dist.src.work}\lib
	mkdir ${build.dist.src.work}\docs
	xcopy /Y/E ${build.home}\docs ${build.dist.src.work}\docs
	mkdir ${build.dist.src.work}\example
	xcopy /Y/E .\example ${build.dist.src.work}\example
