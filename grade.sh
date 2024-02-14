rm -rf student
git clone $1 student

rm -rf grading
mkdir grading

if [[ -f student/ListExamples.java ]]
then
    cp student/ListExamples.java grading/
    cp TestListExamples.java grading/
else
    echo "Missing student/ListExamples.java, did you forget the file or misname it?"
    exit 1 #nonzero exit code to follow convention
fi


cd grading

# what's the classpath argument going to be?
# /home/list-examples-grader/grader/../lib/*.jar refers to the jars
CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
  echo "The program failed to compile, see compile error above"
  exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt



lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
testline=$(cat junit-output.txt | head -n 4 | tail -n 1)
if [[ -z $testline ]]
then
    echo "Successfully Passed!"
else
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$((tests - failures))
    echo "Your score is $successes / $tests"
fi