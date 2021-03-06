#!/bin/bash

red="\e[1;31m"  # Red B
blue="\e[1;34m" # Blue B
green="\e[0;32m"

bwhite="\e[47m" # white background
rst="\e[0m"     # Text reset

st=$1


stage()
{
    let "st += 1"
    echo -en $green"[$st]$rst" $blue"$1...\n"$rst
}

base_path=src
sc_web_path=../../sc-web/client
sc_web_static_path=$sc_web_path/static

stage "Build component"

cd $base_path
python build_components.py -a -i
cd -

append_line()
{
    if grep -Fxq "$3" $1
    then
        # code if found
        echo -en "Link to " $blue"$2"$rst "already exists in " $blue"$1"$rst "\n"
    else
        # code if not found
        echo -en "Append '" $green"$2"$rst "' -> " $green"$1"$rst "\n"
        echo $3 >> $1
    fi
}

append_js()
{
    append_line $1 $2 "<script type=\"text/javascript\" charset=\"utf-8\" src=\"/static/$2\"></script>"
}

append_css()
{
    append_line $1 $2 "<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/$2\" />"
}

stage "Copy component"

cp -Rfv $base_path/components/solution/static/* $sc_web_static_path
cp -Rfv $base_path/components/pencil/static/* $sc_web_static_path
cp -Rfv $base_path/components/alloy/static/* $sc_web_static_path
cp -Rfv $base_path/components/mass_enter/static/* $sc_web_static_path
cp -Rfv $base_path/components/enter/static/* $sc_web_static_path
cp -Rfv $base_path/components/periodic_table/static/* $sc_web_static_path
cp -Rfv $base_path/components/electronLayerBuilder/static/* $sc_web_static_path
cp -Rfv $base_path/components/salt/static/* $sc_web_static_path
cp -Rfv $base_path/components/wavelength/static/* $sc_web_static_path
cp -Rfv $base_path/components/solubility_table/static/* $sc_web_static_path
cp -Rfv $base_path/components/drFormula/static/* $sc_web_static_path
cp -Rfv $base_path/components/indicator_table/static/* $sc_web_static_path

stage "Install component"

append_js $sc_web_path/templates/components.html components/js/chemistry_components/solution_ui_component.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/pencil.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/alloy_ui_component.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/mass_enter.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/enter.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/salt.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/electronLayerBuilder.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/periodic_table.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/wavelength_ui_component.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/solubility_table.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/drFormula.js
append_js $sc_web_path/templates/components.html components/js/chemistry_components/indicator_table.js

append_css $sc_web_path/templates/components.html components/css/chemistry_components/solubility_table.css
append_css $sc_web_path/templates/components.html components/css/chemistry_components/ui_periodic_table.css
append_css $sc_web_path/templates/components.html components/css/chemistry_components/ui_indicator_table.css

cd ../../sc-web/scripts
./install_deps_ubuntu.sh
./prepare_js.sh
python build_components.py -i -a
