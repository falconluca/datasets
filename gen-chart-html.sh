#!/bin/bash

CHART_JS_LIB_PATH='../chart.min.js'

base_layout()
{
    local TITLE="$1"
    local IMG_URL="$2"
    local RELEASE_DATE="$3"
    cat <<EOF
<div class="container">
    <nav class="navbar navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="https://github.com/shaohsiung/OwDataset">github.com/shaohsiung/OwDataset</a>
        </div>
    </nav>

    <nav aria-label="breadcrumb" style="margin-top: 1rem;">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="../index.html">Home</a>
            </li>
            <li class="breadcrumb-item">
                <a href="../index.html#$RELEASE_DATE">$RELEASE_DATE</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">$TITLE</li>
        </ol>
    </nav>
    <div style="display: flex; justify-content: end">
        <a href="$IMG_URL">[保存为图片]</a>
    </div>
    <canvas id="myChart"></canvas>
</div>
<script src="${CHART_JS_LIB_PATH}"></script>
EOF
}    

gen_game_time_html_page() 
{
    local LABELS="[$1]"
    local DATASET_TITLE="$2"
    local DATASET="[$3]"
    local RELEASE_DATE="$4"
    
    local LAYOUT=
    LAYOUT="$(base_layout "$DATASET_TITLE" "TODO" "$RELEASE_DATE")"
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <title>${DATASET_TITLE}</title>
</head>
<body style="display: flex; justify-content: center;">
    ${LAYOUT}
    <script>
        const ctx = document.getElementById('myChart').getContext('2d');
        const myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ${LABELS},
                datasets: [{
                    label: '${DATASET_TITLE}',
                    data: ${DATASET},
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
EOF
}

gen_game_win_count_html_page() 
{
    local LABELS="[$1]"
    local DATASET_TITLE="$2"
    local DATASET="[$3]"
    local RELEASE_DATE="$4"
    
    local LAYOUT=
    LAYOUT="$(base_layout "$DATASET_TITLE" "TODO" "$RELEASE_DATE")"
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <title>${DATASET_TITLE}</title>
</head>
<body style="display: flex; justify-content: center;">
    ${LAYOUT}
    <script>
        const ctx = document.getElementById('myChart').getContext('2d');
        const myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ${LABELS},
                datasets: [{
                    label: '${DATASET_TITLE}',
                    data: ${DATASET},
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
EOF
}

function gen_hit_rate_html_page() 
{
    local LABELS="[$1]"
    local DATASET_TITLE="$2"
    local DATASETS="[$3]"
    local RELEASE_DATE="$4"
    
    local LAYOUT=
    LAYOUT="$(base_layout "$DATASET_TITLE" "TODO" "$RELEASE_DATE")"
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <title>$DATASET_TITLE</title>
</head>
<body style="display: flex; justify-content: center;">
${LAYOUT}
<script>
    const ctx = document.getElementById('myChart').getContext('2d');
    const data = {
        labels: $LABELS,
        datasets: $DATASETS
    };
    const config = {
        type: 'scatter',
        data: data,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
                title: {
                    display: true,
                    text: 'Chart.js Scatter Chart'
                }
            }
        },
    };
    const myChart = new Chart(ctx, config);
</script>
</body>
</html>
EOF
}

function gen_kill_in_survive_html_page() 
{
    local LABELS="[$1]"
    local DATASET_TITLE="$2"
    local DATASETS="[$3]"
    local RELEASE_DATE="$4"
    
    local LAYOUT=
    LAYOUT="$(base_layout "$DATASET_TITLE" "TODO" "$RELEASE_DATE")"
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <title>$DATASET_TITLE</title>
</head>
<body style="display: flex; justify-content: center;">
${LAYOUT}
<script>
    const ctx = document.getElementById('myChart').getContext('2d');
    const data = {
        labels: $LABELS,
        datasets: $DATASETS
    };
    const config = {
        type: 'bubble',
        data: data,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
                title: {
                    display: true,
                    text: 'Chart.js Bubble Chart'
                }
            }
        },
    };
    const myChart = new Chart(ctx, config);
</script>
</body>
</html>
EOF
}

function gen_kill_in_moment_html_page() 
{
    local LABELS="[$1]"
    local DATASET_TITLE="$2"
    local DATASET="[$3]"
    local RELEASE_DATE="$4"
    
    local LAYOUT=
    LAYOUT="$(base_layout "$DATASET_TITLE" "TODO" "$RELEASE_DATE")"
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <title>$DATASET_TITLE</title>
</head>
<body style="display: flex; justify-content: center;">
${LAYOUT}
<script>
    const ctx = document.getElementById('myChart').getContext('2d');
    const data = {
        labels: $LABELS,
        datasets: [
            {
                label: '$DATASET_TITLE',
                data: $DATASET,
            }
        ]
    };
    const config = {
        type: 'polarArea',
        data: data,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
                title: {
                    display: true,
                    text: 'Chart.js Polar Area Chart'
                }
            }
        },
    };
    const myChart = new Chart(ctx, config);
</script>
</body>
</html>
EOF
}

gen_root_html_page()
{
    local DATE="$1"
    cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ow生涯数据 - generated by github.com/shaohsiung/OwDataset</title>
</head>
<body>
    <h1>🦸🏻‍♂️ 🤖 Ow生涯数据(按日期统计): </h1>
    <ul>
        <li>
            <span>$DATE</span>
            <p>
                <a href="$DATE/游戏时间.html">🕐 游戏时间</a>
                <a href="$DATE/比赛胜利.html">🍾 比赛胜利</a>
                <a href="$DATE/武器命中率.html">🎯 武器命中率</a>
                <a href="$DATE/单次存活时消灭.html">🔫 单次存活时消灭</a>
                <a href="$DATE/最佳瞬间消灭.html">⚔️ 最佳瞬间消灭</a>
            </p>
        </li>
    </ul>
</body>
</html>
EOF
}
