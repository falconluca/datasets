#!/bin/bash -e

COOKIE=

UNIX_TIMESTAMP=1637815519587
CURRENT_DATE=$(date +%F)

PROFILE=
GAME_DATA=

GAME_TIME_TITLE='游戏时间'
GAME_TIME_ID=
declare -a GAME_TIME_DATATABLE
declare GAME_TIME_BAR_CHART_LABELS
declare GAME_TIME_BAR_CHART_DATASET

GAME_WIN_COUNT_TITLE='比赛胜利'
GAME_WIN_COUNT_ID=
declare -a GAME_WIN_COUNT_DATATABLE
declare GAME_WIN_COUNT_BAR_CHART_LABELS
declare GAME_WIN_COUNT_BAR_CHART_DATASET

HIT_RATE_TITLE='武器命中率'
HIT_RATE_ID=
declare -a HIT_RATE_DATATABLE
# 目标攻防消灭
ENEMIES_KILLED_ID='"0x086000000000031C"'
declare -a ENEMIES_KILLED_DATATABLE
HIT_RATE_LABELS=
HIT_RATE_DATASETS=

KILL_IN_SURVIVE_TITLE='单次存活时消灭'
KILL_IN_SURVIVE_ID=
declare -a KILL_IN_SURVIVE_DATATABLE
# 阵亡
NUM_OF_DEATHS_ID='"0x086000000000002A"'
declare -a NUM_OF_DEATHS_DATATABLE

KILL_IN_MOMENT_TITLE='最佳瞬间消灭'
KILL_IN_MOMENT_ID=
declare -a KILL_IN_MOMENT_DATATABLE
declare KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS
declare KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET

DOCKER_INSTALL=$1

source util.sh
source gen-chart-img.sh
source gen-chart-html.sh

check_dependencies() 
{
    jq --help > /dev/null
    if [ $(echo $?) != 0 ]; then
        echo "==> jq not install yet"
        exit 1
    fi
}

set_up_cookie() 
{
    COOKIE=$(cat cookiefile | xargs echo -n)
    if [ -z "${COOKIE}" ]; then
        COOKIE=$(cat cookiefile.example | xargs echo -n)
    fi
}

fetch_game_data() {
#    PROFILE=$(curl -X POST "https://ow.blizzard.cn/action/career/profile?${UNIX_TIMESTAMP}" -H "cookie: ${COOKIE}" --compressed)
#    GAME_DATA=$(curl -X POST "https://ow.blizzard.cn/action/career/profile/gamedata?${UNIX_TIMESTAMP}" -H "cookie: ${COOKIE}" --compressed)
    PROFILE=$(cat ./mock/profile.json)
    GAME_DATA=$(cat ./mock/game_data.json)
    # TODO(Luca): error handle
    # echo "PROFILE: $PROFILE"
    # {"status":"fail","msg":"login","data":null}
}

setup_other_hero_metas()
{
    DATA_META_LIST=$(echo "${GAME_DATA}" | jq -c '.heroComparison | .[]')
    for DATA_META in $DATA_META_LIST; do
      DATA_META_NAME=$(remove_quotes "$(echo $DATA_META | jq -c '.name')")
      DATA_META_ID=$(echo $DATA_META | jq -c '.id')
      if [ $DATA_META_NAME == $GAME_TIME_TITLE ]; then
          GAME_TIME_ID=$DATA_META_ID
      fi
      if [ $DATA_META_NAME == $GAME_WIN_COUNT_TITLE ]; then
          GAME_WIN_COUNT_ID=$DATA_META_ID
      fi
      if [ $DATA_META_NAME == $HIT_RATE_TITLE ]; then
          HIT_RATE_ID=$DATA_META_ID
      fi
      if [ $DATA_META_NAME == $KILL_IN_SURVIVE_TITLE ]; then
          KILL_IN_SURVIVE_ID=$DATA_META_ID
      fi
      if [ $DATA_META_NAME == $KILL_IN_MOMENT_TITLE ]; then
          KILL_IN_MOMENT_ID=$DATA_META_ID
      fi
    done 
}

build_game_time_datatable() 
{
    GAME_TIME_LIST=$(echo "${PROFILE}" | \
        jq -c ".data.heroComparison.unranked.$GAME_TIME_ID | .[] | {id: .hero, v: .value}")
    for HERO_GAME_TIME in ${GAME_TIME_LIST}; do
        HERO_ID=$(remove_quotes "$(echo "${HERO_GAME_TIME}" | jq '.id')")
        HREO_GAME_TIME=$(echo "${HERO_GAME_TIME}" | jq '.v')

        GAME_TIME_DATATABLE[${HERO_ID}]="${HREO_GAME_TIME}"
    done
    #echo "==> GAME_TIME_DATATABLE: ${GAME_TIME_DATATABLE[*]}"
}

# TODO(by Luca): refactor 抽取重复代码
build_game_win_count_datatable()
{
    GAME_WIN_COUNT_LIST=$(echo "${PROFILE}" | \
        jq -c ".data.heroComparison.unranked.$GAME_WIN_COUNT_ID | .[] | {id: .hero, v: .value}")
    for GAME_WIN_COUNT in ${GAME_WIN_COUNT_LIST}; do
      HERO_ID=$(remove_quotes "$(echo "${GAME_WIN_COUNT}" | jq '.id')")
      VALUE=$(echo "${GAME_WIN_COUNT}" | jq '.v')
      
      GAME_WIN_COUNT_DATATABLE[${HERO_ID}]="${VALUE}"
    done
    #echo "==> GAME_WIN_COUNT_DATATABLE: ${GAME_WIN_COUNT_DATATABLE[*]}"
}

# TODO(by Luca): refactor 抽取重复代码
build_hit_rate_datatable()
{
    HIT_RATE_LIST=$(echo "${PROFILE}" | \
        jq -c ".data.heroComparison.unranked.$HIT_RATE_ID | .[] | {id: .hero, v: .value}")
    for HIT_RATE in ${HIT_RATE_LIST}; do
      HERO_ID=$(remove_quotes "$(echo "${HIT_RATE}" | jq '.id')")
      VALUE=$(echo "${HIT_RATE}" | jq '.v')
      
      HIT_RATE_DATATABLE[${HERO_ID}]="${VALUE}"
    done
    #echo "==> HIT_RATE_DATATABLE: ${HIT_RATE_DATATABLE[*]}"
}

# TODO(by Luca): refactor 抽取重复代码
build_kill_in_survive_datatable()
{
    KILL_IN_SURVIVE_LIST=$(echo "${PROFILE}" | \
        jq -c ".data.heroComparison.unranked.$KILL_IN_SURVIVE_ID | .[] | {id: .hero, v: .value}")
    for KILL_IN_SURVIVE in ${KILL_IN_SURVIVE_LIST}; do
      HERO_ID=$(remove_quotes "$(echo "${KILL_IN_SURVIVE}" | jq '.id')")
      VALUE=$(echo "${KILL_IN_SURVIVE}" | jq '.v')
      
      KILL_IN_SURVIVE_DATATABLE[${HERO_ID}]="${VALUE}"
    done
    #echo "==> KILL_IN_SURVIVE_DATATABLE: ${KILL_IN_SURVIVE_DATATABLE[*]}"
}

# TODO(by Luca): refactor 抽取重复代码
build_kill_in_moment_datatable()
{
    KILL_IN_MOMENT_LIST=$(echo "${PROFILE}" | \
        jq -c ".data.heroComparison.unranked.$KILL_IN_MOMENT_ID | .[] | {id: .hero, v: .value}")
    for KILL_IN_MOMENT in ${KILL_IN_MOMENT_LIST}; do
      HERO_ID=$(remove_quotes "$(echo "${KILL_IN_MOMENT}" | jq '.id')")
      VALUE=$(echo "${KILL_IN_MOMENT}" | jq '.v')
      
      KILL_IN_MOMENT_DATATABLE[${HERO_ID}]="${VALUE}"
    done
    #echo "==> KILL_IN_MOMENT_DATATABLE: ${KILL_IN_MOMENT_DATATABLE[*]}"
}

build_enemies_killed_and_deaths_datatable() {
    HERO_STATS_LIST=$(echo "${PROFILE}" | jq -c '.data.careerStats.unranked.stats')
    HERO_STATS_KEYS=$(echo "${PROFILE}" | jq -c '.data.careerStats.unranked.stats | keys | .[]')
    for HERO_ID in $HERO_STATS_KEYS; do
        ENEMIES_KILLED=$(echo "$HERO_STATS_LIST" | jq -c ".${HERO_ID}.${ENEMIES_KILLED_ID}")
        NUM_OF_DEATHS=$(echo "$HERO_STATS_LIST" | jq -c ".${HERO_ID}.${NUM_OF_DEATHS_ID}")
        #echo "hero: $HERO_ID, ENEMIES_KILLED: $ENEMIES_KILLED, NUM_OF_DEATHS: $NUM_OF_DEATHS"
        HERO_ID=$(remove_quotes "${HERO_ID}")
        ENEMIES_KILLED_DATATABLE[${HERO_ID}]="${ENEMIES_KILLED}"
        NUM_OF_DEATHS_DATATABLE[${HERO_ID}]="${NUM_OF_DEATHS}"
    done
    #debug_build_enemies_killed_and_deaths_datatable
}

debug_build_enemies_killed_and_deaths_datatable() {
    echo "==> 目标攻防消灭 datatable: ${ENEMIES_KILLED_DATATABLE[*]}"
    echo "==> 阵亡 datatable: ${NUM_OF_DEATHS_DATATABLE[*]}"
}

attach_all() {
    # TODO refactor to pie
    # https://www.chartjs.org/docs/latest/samples/other-charts/pie.html
    HEROES=$(echo "${GAME_DATA}" | jq -c '.heroesMap | .[] | { id: .id, name: .displayName }')
    for HERO in ${HEROES}; do
        HERO_ID=$(remove_quotes "$(echo "${HERO}" | jq '.id')")
        HERO_NAME=$(remove_quotes "$(echo "${HERO}" | jq '.name')")
        
        # 游戏时间
        attach_game_time_bar_labels_and_dataset $HERO_ID $HERO_NAME
        
        # 比赛时间
        attach_game_win_count_bar_labels_and_dataset $HERO_ID $HERO_NAME
        
        # 武器命中率
        attach_hit_rate_labels_and_dataset $HERO_ID $HERO_NAME
        
        # 单次存活时消灭
        attach_kill_in_survive_bubble_labels_and_dataset $HERO_ID $HERO_NAME
        
        # 最佳瞬间消灭
        attach_kill_in_moment_labels_and_dataset $HERO_ID $HERO_NAME
    done
    #debug_attach_all
}

debug_attach_all() {
    echo "==> 游戏时间 labels: ${GAME_TIME_BAR_CHART_LABELS}"
    echo "==> 游戏时间 dataset: ${GAME_TIME_BAR_CHART_DATASET}"

    echo "==> 比赛胜利 labels: ${GAME_WIN_COUNT_BAR_CHART_LABELS}"
    echo "==> 比赛胜利 dataset: ${GAME_WIN_COUNT_BAR_CHART_DATASET}"

    echo "==> 武器命中率 labels: ${HIT_RATE_LABELS}"
    echo "==> 武器命中率 dataset: ${HIT_RATE_DATASETS}"

    echo "==> 单次存活时消灭 labels: ${KILL_IN_SURVIVE_LABELS}"
    echo "==> 单次存活时消灭 dataset: ${KILL_IN_SURVIVE_DATASETS}"

    echo "==> 最佳瞬间消灭 labels: ${KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS}"
    echo "==> 最佳瞬间消灭 dataset: ${KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET}"
}

# TODO refactor to pie
# https://www.chartjs.org/docs/latest/samples/other-charts/pie.html
attach_game_time_bar_labels_and_dataset() {
    local ID=$1
    
    local NAME=$2
    if [ "$NAME" == "所有英雄" ]; then
      return
    fi
    
    local VALUE=${GAME_TIME_DATATABLE[${ID}]}
    if [ -z "${GAME_TIME_BAR_CHART_DATASET}" ]; then
        GAME_TIME_BAR_CHART_DATASET="$VALUE"
    else 
        GAME_TIME_BAR_CHART_DATASET="${GAME_TIME_BAR_CHART_DATASET},$VALUE"
    fi

    if [ -z "${GAME_TIME_BAR_CHART_LABELS}" ]; then
        GAME_TIME_BAR_CHART_LABELS="'$NAME'"
    else 
        GAME_TIME_BAR_CHART_LABELS="${GAME_TIME_BAR_CHART_LABELS},'$NAME'"
    fi
}

# https://www.chartjs.org/docs/latest/samples/bar/border-radius.html
attach_game_win_count_bar_labels_and_dataset()
{
    local ID=$1
    
    local NAME=$2
    if [ "$NAME" == "所有英雄" ]; then
      return
    fi
    
    local VALUE=${GAME_WIN_COUNT_DATATABLE[${ID}]}
    # [: ==: unary operator expected
    # https://stackoverflow.com/a/13618376/9076327 https://codefather.tech/blog/bash-unary-operator-expected/
    if [ "$VALUE" == 0 ]; then
      # 暂不统计游戏时间为0的英雄
      return
    fi
    
    if [ -z "${GAME_WIN_COUNT_BAR_CHART_DATASET}" ]; then
        GAME_WIN_COUNT_BAR_CHART_DATASET="$VALUE"
    else 
        GAME_WIN_COUNT_BAR_CHART_DATASET="${GAME_WIN_COUNT_BAR_CHART_DATASET},$VALUE"
    fi
    
    if [ -z "${GAME_WIN_COUNT_BAR_CHART_LABELS}" ]; then
        GAME_WIN_COUNT_BAR_CHART_LABELS="'${NAME}'"
    else 
        GAME_WIN_COUNT_BAR_CHART_LABELS="${GAME_WIN_COUNT_BAR_CHART_LABELS},'${NAME}'"
    fi
}

# https://www.chartjs.org/docs/latest/samples/other-charts/scatter.html
attach_hit_rate_labels_and_dataset() {
    # labels: []
    # datasets: [{label: 'Dataset 2', data: [[5, 7]]}]  
    # PS: data: ["英雄武器命中率, 目标攻防消灭"]
    local ID=$1
    
    local NAME=$2
    if [ "$NAME" == "所有英雄" ]; then
      return
    fi
    
    local ENEMIES_KILLED_VALUE=${ENEMIES_KILLED_DATATABLE[${ID}]}
    if [ "$ENEMIES_KILLED_VALUE" == "null" ]; then
        return
    fi
    # FIXME {label:'西格玛',data:[[,]]},
    if [ -z "$ENEMIES_KILLED_VALUE" ]; then
        return
    fi
    
    local VALUES=${HIT_RATE_DATATABLE[${HERO_ID}]}
    if [ -z "$VALUES" ]; then
        return
    fi
    if [ "$VALUES" == "0" ]; then
        return
    fi
    
    if [ -z "$HIT_RATE_LABELS" ]; then
        HIT_RATE_LABELS="'$NAME'"
    else 
        HIT_RATE_LABELS="$HIT_RATE_LABELS,'$NAME'"
    fi
    if [ -z "$HIT_RATE_DATASETS" ]; then
        HIT_RATE_DATASETS="{label:'$NAME',data:[[${VALUES},${ENEMIES_KILLED_VALUE}]]}"
    else 
        HIT_RATE_DATASETS="$HIT_RATE_DATASETS,{label:'$NAME',data:[[${VALUES},${ENEMIES_KILLED_VALUE}]]}"
    fi
}

KILL_IN_SURVIVE_LABELS=
KILL_IN_SURVIVE_DATASETS=

# https://www.chartjs.org/docs/latest/samples/other-charts/bubble.html
attach_kill_in_survive_bubble_labels_and_dataset() {
    # "存活时消灭,阵亡"
    local ID=$1
    
    local NAME=$2
    if [ "$NAME" == "所有英雄" ]; then
      return
    fi
    
    local NUM_OF_DEATHS_VALUE=${NUM_OF_DEATHS_DATATABLE[${ID}]}
    if [ "$NUM_OF_DEATHS_VALUE" == "null" ]; then
        return
    fi
    # FIXME {label:'西格玛',data:[[,]]},
    if [ -z "$NUM_OF_DEATHS_VALUE" ]; then
        return
    fi
    
    local VALUES=${KILL_IN_SURVIVE_DATATABLE[${HERO_ID}]}
    if [ -z "$VALUES" ]; then
        return
    fi
    if [ "$VALUES" == "0" ]; then
        return
    fi
    
    if [ -z "$KILL_IN_SURVIVE_LABELS" ]; then
        KILL_IN_SURVIVE_LABELS="'$NAME'"
    else 
        KILL_IN_SURVIVE_LABELS="$KILL_IN_SURVIVE_LABELS,'$NAME'"
    fi
    if [ -z "$KILL_IN_SURVIVE_DATASETS" ]; then
        KILL_IN_SURVIVE_DATASETS="{label:'$NAME',data:[[${VALUES},${NUM_OF_DEATHS_VALUE}]]}"
    else 
        KILL_IN_SURVIVE_DATASETS="$KILL_IN_SURVIVE_DATASETS,{label:'$NAME',data:[[${VALUES},${NUM_OF_DEATHS_VALUE}]]}"
    fi
}

# https://www.chartjs.org/docs/latest/samples/other-charts/polar-area.html
attach_kill_in_moment_labels_and_dataset()
{
    local ID=$1
    local NAME=$2
    
    local VALUE=${KILL_IN_MOMENT_DATATABLE[${ID}]}
    if [ "$NAME" == "所有英雄" ]; then
      # id: 0x02E00000FFFFFFFF
      return
    fi
    if [ "$VALUE" == 0 ]; then
      # 暂不统计最佳瞬间消灭为0的英雄
      return
    fi
    
    if [ -z "${KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET}" ]; then
        KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET="$VALUE"
    else 
        KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET="${KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET},$VALUE"
    fi
    
    if [ -z "${KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS}" ]; then
        KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS="'${NAME}'"
    else 
        KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS="${KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS},'${NAME}'"
    fi
}

download_bar_chart_img() {
    BAR_CHART_IMG=$(gen_bar_chart_img ${GAME_TIME_TITLE} ${BAR_CHART_LABELS} ${BAR_CHART_DATASET})
    BAR_CHART_IMG_NAME=$(gen_bar_chart_img_name ${GAME_TIME_TITLE} "${CURRENT_DATE}")
    echo "==> 开始下载图片..."
    wget -O "dist/${BAR_CHART_IMG_NAME}" "${BAR_CHART_IMG}" >/dev/null 2>&1
    echo "==> 图片下载成功"
}

compose_game_time_html()
{
    gen_game_time_html_page "$GAME_TIME_BAR_CHART_LABELS" \
        $GAME_TIME_TITLE \
        "${GAME_TIME_BAR_CHART_DATASET}" \
        "${CURRENT_DATE}" > \
        "./dist/${CURRENT_DATE}/$GAME_TIME_TITLE.html"

    # 下载图片
    #download_bar_chart_img
    #gen_bar_chart_img_html ${GAME_TIME_TITLE} "${BAR_CHART_IMG_NAME}" > "dist/bar_img.html"
}

compose_game_win_count_html() 
{
    gen_game_win_count_html_page "$GAME_WIN_COUNT_BAR_CHART_LABELS" \
        $GAME_WIN_COUNT_TITLE \
        "${GAME_WIN_COUNT_BAR_CHART_DATASET}" \
        "${CURRENT_DATE}" > \
        "./dist/${CURRENT_DATE}/$GAME_WIN_COUNT_TITLE.html"
}

compose_hit_rate_html()
{
    gen_hit_rate_html_page "$HIT_RATE_LABELS" \
        $HIT_RATE_TITLE \
        "${HIT_RATE_DATASETS}" \
        "${CURRENT_DATE}" > \
        "./dist/${CURRENT_DATE}/$HIT_RATE_TITLE.html"
}
compose_kill_in_survive_html()
{
    gen_kill_in_survive_html_page "$KILL_IN_SURVIVE_LABELS" \
        $KILL_IN_SURVIVE_TITLE \
        "${KILL_IN_SURVIVE_DATASETS}" \
        "${CURRENT_DATE}" > \
        "./dist/${CURRENT_DATE}/$KILL_IN_SURVIVE_TITLE.html"
}

compose_kill_in_moment_html()
{
    gen_kill_in_moment_html_page "$KILL_IN_MOMENT_POLAR_AREA_CHART_LABELS" \
        $KILL_IN_MOMENT_TITLE \
        "${KILL_IN_MOMENT_POLAR_AREA_CHART_DATASET}" \
        "${CURRENT_DATE}" > \
        "./dist/${CURRENT_DATE}/$KILL_IN_MOMENT_TITLE.html"
}

main() {
    check_dependencies
    set_up_cookie
    fetch_game_data
    setup_other_hero_metas
    
    build_game_time_datatable
    build_game_win_count_datatable
    build_hit_rate_datatable
    build_kill_in_survive_datatable
    build_kill_in_moment_datatable
    
    build_enemies_killed_and_deaths_datatable
    
    # TODO(by Luca): sort dataset
    attach_all
    
    mkdir -p "./dist/${CURRENT_DATE}"
    
    #wget -O "dist/chart.min.js" "https://cdn.jsdelivr.net/npm/chart.js@3.6.2/dist/chart.min.js" >/dev/null 2>&1
    
    compose_game_time_html
    compose_game_win_count_html
    compose_hit_rate_html
    compose_kill_in_survive_html
    compose_kill_in_moment_html
    
    gen_root_html_page "${CURRENT_DATE}" > "./dist/index.html"
    
    # local install
    #mv_to_nginx_if_necessary else // keep dist then exit 0
}

main
