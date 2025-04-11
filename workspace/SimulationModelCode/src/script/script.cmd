if not exist executables mkdir executables
if not exist output mkdir output

java -jar rmc-2.13.jar -s ../SimulationModelCode.rebeca -p ./properties/rule19.property -e TIMED_REBECA -x -o ./cppfiles/rmc19
g++ ./cppfiles/rmc19/*.cpp -w -o executables\rule19  
executables\rule19.exe > output\rule19.txt

java -jar rmc-2.13.jar -s ../SimulationModelCode.rebeca -p ./properties/rule22.property -e TIMED_REBECA -x -o ./cppfiles/rmc22
g++ ./cppfiles/rmc22/*.cpp -w -o executables\rule22  
executables\rule22.exe > output\rule22.txt

java -jar rmc-2.13.jar -s ../SimulationModelCode.rebeca -p ./properties/rule23.property -e TIMED_REBECA -x -o ./cppfiles/rmc23
g++ ./cppfiles/rmc23/*.cpp -w -o executables\rule23
executables\rule23.exe > output\rule23.txt

java -jar rmc-2.13.jar -s ../SimulationModelCode.rebeca -p ./properties/622.property -e TIMED_REBECA -x -o ./cppfiles/rmc622
g++ ./cppfiles/rmc622/*.cpp -w -o executables\rule622  
executables\rule622.exe > output\rule622.txt

java -jar rmc-2.13.jar -s ../SimulationModelCode.rebeca -p ./properties/B11.property -e TIMED_REBECA -x -o ./cppfiles/rmcB11
g++ ./cppfiles/rmcB11/*.cpp -w -o executables\ruleB11
executables\ruleB11.exe > output\ruleB11.txt

java -jar rmc-2.13.jar -s ../SimulationModelCode.rebeca -p ./properties/B12.property -e TIMED_REBECA -x -o ./cppfiles/rmcB12
g++ ./cppfiles/rmcB12/*.cpp -w -o executables\ruleB12
executables\ruleB12.exe > output\ruleB12.txt