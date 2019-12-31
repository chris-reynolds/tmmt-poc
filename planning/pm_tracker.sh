#@!bash
# project_root="~/Desktop/projects/tmmt-poc"
# cd $project_root
cd ~/Desktop/projects/tmmt-poc
find . -name '*.md' |xargs grep 'TASK:' >planning/tmp_tasks.txt
find . -name '*.dart' |xargs grep 'TASK:' >>planning/tmp_tasks.txt
dart src/bin/pmTaskAnal.dart
echo "comleted $0"

