#!/usr/bin/env bash

set -euo pipefail

if [ -z "$1" ]
then
    echo "usage: $0 [project_name]"
    exit 1
fi

name="$1"
demo_name="${name}.Demo"
test_name="${name}.Test"

mkdir $name
cd $name

dotnet new sln

dotnet new classlib -o $name
dotnet sln add "${name}/${name}.csproj"

dotnet new console -o "${name}.Demo"
dotnet sln add "${demo_name}/${demo_name}.csproj"
dotnet add "${demo_name}/${demo_name}.csproj" reference "${name}/${name}.csproj"

dotnet new xunit -o "${name}.Test"
dotnet sln add "${test_name}/${test_name}.csproj"
dotnet add "${test_name}/${test_name}.csproj" reference "${name}/${name}.csproj"

cat << EOF > .gitignore
**/bin/
**/obj/
EOF

git init