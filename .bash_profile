
alias glp='git log --pretty=format:"%h %an %ar -%s"' # short git logs
alias l.='ls -d .* --color=auto' # show hidden only
alias ll='ls -hl' # human readable & long
alias lp='ls -FC --color=auto' # classify & color
alias ls='ls --color=auto'



function cs () {
cd "$@" && lp
}

export PYTHONPATH=/home/USER/etl-fraud/lib:/home/USER/ma-scripts:/home/USER/analytics-scripts:$PYTHONPATH
export PATH=/opt/py27/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
export MPLCONFIGDIR=/home/USER/
export HDF5_DISABLE_VERSION_CHECK=2
export R_HOME=/usr/local/lib64/R

alias myps='ps axww -F | head -1; ps axww -F | grep -P "^523|USER"; ps axww -F | head -1'
#alias nz-prod='nzsql -host vip1.npsc.lax1 -u -pw -db ADNEXUS_RPT_PROD'
alias mysql-prod='mysql --prompt "mysql-prod> " -u USER  -pPASS$ -hmysql-slave.prod.nym1.adnxs.net api'
alias vi='vim'
alias nz-sand='nzsql -host 01.npsb.lax1 -u u_USER -pw  -db ADNEXUS_RPT_PROD'
alias vertica='LANG=en_US.UTF-8 /opt/vertica/bin/vsql -h vertica-internal.prod.adnxs.net -U USER -w '
alias vertdev-server='ssh -AY -t jump.adnxs.net ssh -AY 06.vertica.test01.nym1'
export LNK_DIR=/home/USER/.link
### GIT commands
alias glp='git log --pretty=format: "%h %an %ar -%s"'

cdp () {
	cd "$(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__[:-1]))")"
}

# Here are the functions I have in my .bashrc

where () {
	echo "$(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__[:-1]))")"
}
packages () {
	python -c "print '\n'.join(sorted([str(x) for x in __import__('pkg_resources').working_set]))"
}
modules () {
	python -c "import pkgutil; print '\n'.join(sorted([m[1] for m in pkgutil.iter_modules()]))"
}

function blacklist_domainno_email() {
python2.7 /home/USER/etl-fraud/domain_blacklist_no_email.py $@
  }

function blacklist_domainemail() {
python2.7 /home/USER/etl-fraud/domain_blacklist_email.py $@
    }
function mem_usage() {
  python2.7 ~/scripts/mem_usage.py
  }

function get_nz_tables() {
  echo $@
    python2.7 ~/scripts/python_nz_lookup.py $@ > nz_lookup.tmp
    nzsql -u u_USER -pw  -host vip1.npsc.nym2 -dADNEXUS_RPT_PROD -f nz_lookup.tmp
    rm nz_lookup.tmp
}

function get_vert_tables() {
    echo $@
        python2.7 ~/scripts/python_vert_lookup.py $@ > nz_lookup.tmp
        LANG=en_US.UTF-8 /opt/vertica/bin/vsql -U USER -w -h vertica-internal.prod.adnxs.net -f nz_lookup.tmp
        rm nz_lookup.tmp
}

function domain_pub() {
echo $@
python2.7 /home/USER/etl-fraud/domain_scripts/python_pub_lookup.py $@
    }

function domain_sellers() {
echo $@
python2.7 /home/USER/etl-fraud/domain_scripts/domain_sellers.py $@
}

function domain_tags() {
echo $@
python2.7 /home/USER/etl-fraud/domain_scripts/domain_tags.py $@
}
function pub_domains() {
  echo $@
  python2.7 /home/USER/etl-fraud/domain_scripts/pub_domains.py $@
}

function tag_domainsclick() {
  echo $@
  python2.7 /home/USER/etl-fraud/domain_scripts/tag_domains.py $@
}


function tag_domains() {
  echo $@
  python2.7 /home/USER/inv-quality/simple_scripts/tag_domains.py $@
}


function nzxls() {
    echo "Running query";
    nzsql -h vip1.npsc.lax1 -u u_USER -pw -db adnexus_rpt_prod -o $2 -f $1;
    sed -e "s/|/,/ig" $2 > $2.csv;
    echo "Please run 'pull ${2}.csv'  on your local machine";
}

AUTHDIR="/home/USER/"
VERBOSE=1
API_SAND="api-sand"
DW_SAND="dw-sand"
API_PROD="api-prod"
DW_PROD="dw-prod"
API="api"
DW="dw"
SAND="sand"
PROD="prod"
API_SAND_COOKIE="apisandcookie"
API_PROD_COOKIE="apiprodcookie"
DW_SAND_COOKIE="dwsandcookie"
DW_PROD_COOKIE="dwprodcookie"
CURR_COOKIE=""
CURR_URL=""
CURR_CONN=""
API_SAND_URL=""
DW_SAND_URL=""
API_PROD_URL=""
DW_PROD_URL=""
AUTH_ERROR="ERROR: You must authentic first with \"auth\". Please use chelp for more information"
JSON_PRINT=""
 
function chelp() {
    echo ""
    echo "The available commands are:"
    echo "    auth(service-type)"
    echo "    switchto(user)"
    echo "    curlget(target)"
    echo "    meta(service)"
    echo "    curlput(target, json)"
    echo "    curlputfile(target, json filename)"
    echo "    curlpost(target, json)"
    echo "    curlpostfile(target, json filename)"
    echo ""
    echo "The service-types are:"
    echo "    api-prod"
    echo "    dw-prod"
    echo "    api-sand"
    echo "    dw-sand"    
    echo ""
}
function auth() {
    if [ "$1" == "$API_SAND" ]; then
        curl -b $API_SAND_COOKIE -c $API_SAND_COOKIE -X POST --data-binary @${AUTHDIR}sand_authfile "${API_SAND_URL}auth"
        CURR_COOKIE=$API_SAND_COOKIE
        CURR_URL=$API_SAND_URL
        CURR_CONN="${API}-${SAND}"
    elif [ "$1" == "$DW_SAND" ]; then
        CMD="curl -b $DW_SAND_COOKIE -c $DW_SAND_COOKIE -X POST --data-binary @${AUTHDIR}sand_authfile "${DW_SAND_URL}auth""
        echo "Using ${CMD}"
	eval "${CMD}"
	CURR_COOKIE=$DW_SAND_COOKIE
        CURR_URL=$DW_SAND_URL
        CURR_CONN="${DW}-${SAND}"
    elif [ "$1" ==  "$API_PROD" ]; then
        curl -b $API_PROD_COOKIE -c $API_PROD_COOKIE -X POST --data-binary @${AUTHDIR}prod_authfile "${API_PROD_URL}auth"
        CURR_COOKIE=$API_PROD_COOKIE
        CURR_URL=$API_PROD_URL
        CURR_CONN="${API}-${PROD}"
    elif [ "$1" == "$DW_PROD" ]; then
        curl -b $DW_PROD_COOKIE -c $DW_PROD_COOKIE -X POST --data-binary @${AUTHDIR}prod_authfile "${DW_PROD_URL}auth"
        CURR_COOKIE=$DW_PROD_COOKIE
        CURR_URL=$DW_PROD_URL
        CURR_CONN="${DW}-${PROD}"
    else
        echo "The proper usage is auth [api-prod/dw-prod/api-sand/dw-sand]"
    fi
    if which json_reformat >/dev/null; then
        JSON_PRINT=" | json_reformat"
    fi
}
 
 
function switchto() {
    SWVAL="'{\"auth\":{\"switch_to_user\":${1} }}'"
    if [ $VERBOSE -gt 0 ]; then  
        echo "using ${CURR_CONN} ${SWVAL}"
    fi
    eval "curl -b $CURR_COOKIE -c $CURR_COOKIE -X POST -d ${SWVAL} ${CURR_URL}auth $JSON_PRINT"
}
 
function curlget() {
    if [ -z $CURR_CONN ]; then
        echo $AUTH_ERROR
    else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE \"${CURR_URL}${1}\" $JSON_PRINT"
        if [ $VERBOSE -gt 0 ]; then
            echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
}
 
function curlgetraw() {
    if [ -z $CURR_CONN ]; then
        echo $AUTH_ERROR
    else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE \"${CURR_URL}${1}\""
        if [ $VERBOSE -gt 0 ]; then
            echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
}
 
function meta() {
        if [ -z $CURR_CONN ]; then
                echo $AUTH_ERROR
        else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE \"${CURR_URL}${1}/meta\" $JSON_PRINT"
        if [ $VERBOSE -gt 0 ]; then
           echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
}
 
 
function curlput() {    
        if [ -z $CURR_CONN ]; then
                echo $AUTH_ERROR
        else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE -X PUT -d '${2}' \"${CURR_URL}${1}\" $JSON_PRINT"
        if [ $VERBOSE -gt 0 ]; then
           echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
}
 
function curlputfile() {
        if [ -z $CURR_CONN ]; then
                echo $AUTH_ERROR
        else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE -X PUT --data-binary @${2} \"${CURR_URL}${1}\" $JSON_PRINT"    
        if [ $VERBOSE -gt 0 ]; then
           echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
}
 
function curlpost() {
        if [ -z $CURR_CONN ]; then
                echo $AUTH_ERROR
        else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE -X POST -d '${2}' \"${CURR_URL}${1}\" $JSON_PRINT"
        if [ $VERBOSE -gt 0 ]; then
           echo "Using: ${CMD}"
        fi
        eval "${CMD}"
 
    fi
}
 
function curlpostfile() {
        if [ -z $CURR_CONN ]; then
                echo $AUTH_ERROR
        else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE -X POST --data-binary @${2} \"${CURR_URL}${1}\" $JSON_PRINT"
        if [ $VERBOSE -gt 0 ]; then
           echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
 
}
 
function curldelete() {
        if [ -z $CURR_CONN ]; then
               echo $AUTH_ERROR
        else
        CMD="curl -b $CURR_COOKIE -c $CURR_COOKIE -X DELETE -d '${2}' \"${CURR_URL}${1}\" $JSON_PRINT"
        if [ $VERBOSE -gt 0 ]; then
           echo "Using: ${CMD}"
        fi
        eval "${CMD}"
    fi
}

    
