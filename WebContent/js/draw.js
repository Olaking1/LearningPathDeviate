/**
 * 
 */
        // 路径配置
        require.config({
            paths:{ 
                'echarts' : 'js/echarts',
                'echarts/chart/pie' : 'js/echarts'
            }
        });
        
        
        // 使用
        require(
            [
                'echarts',
                'echarts/chart/pie' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                
                option = {
    title : {
        text: '知识地图',
        x:'right',
        y:'bottom'
    },
    tooltip : {
        trigger: 'item',
        formatter: '{a} : {b}'
    },
    toolbox: {
        show : true,
        feature : {
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    legend: {
        x: 'left',
        data:['目标结点','未学习结点','已学习结点','推荐路径']
    },
    series : [
        {
            type:'force',
            name : "知识地图",
            ribbonType: false,
            categories : [
                {
                    name: '目标结点',
                },
                {
                	 name: '未学习结点',
                	 symbol: 'circle'
                   
                },
                {
                	 name: '推荐路径',
                	 symbol: 'diamond'
                },
                {
                    name:'已学习结点',
                    symbol: 'circle'
                }
            ],
            itemStyle: {
                normal: {
                    label: {
                        show: true,
                        textStyle: {
                            color: '#333'
                        }
                    },
                    nodeStyle : {
                        brushType : 'both',
                        borderColor : 'rgba(255,215,0,0.4)',
                        borderWidth : 1
                    }
                },
                emphasis: {
                    label: {
                        show: false
                        // textStyle: null      // 默认使用全局文本样式，详见TEXTSTYLE
                    },
                    nodeStyle : {
                        //r: 30
                    },
                    linkStyle : {}
                }
            },
            minRadius : 15,
            maxRadius : 25,
            gravity: 1.1,
            scaling: 1,		//！缩放比例（排斥力）
            draggable: false,		//！！所有节点可拖动，默认为false
            linkSymbol: 'arrow',
            steps: 10,
            coolDown: 0.9,
            //preventOverlap: true,
           
            nodes:[
                {
                	<jsp:useBean id="msBean" class="spare.MSBean" />
                    category:0, name: '<jsp:getProperty name="msBean" property="targetLabel"/>', value : 10,
                    symbolSize: [60, 35],
                    draggable: true,
                    itemStyle: {
                        normal: {
                            label: {
                                position: 'right',
                                textStyle: {
                                    color: 'black'
                                }
                            }
                        }
                    }
                },
                	<jsp:getProperty name="msBean" property="w"/>
            ],
            links : [
                     <jsp:getProperty name="msBean" property="map"/>
            ]
        }
    ]
};
var ecConfig = require('echarts/config');
function focus(param) {
    var data = param.data;
    var links = option.series[0].links;
    var nodes = option.series[0].nodes;
    if (
        data.source != null
        && data.target != null
    ) { //点击的是边
        var sourceNode = nodes.filter(function (n) {return n.name == data.source})[0];
        var targetNode = nodes.filter(function (n) {return n.name == data.target})[0];
        console.log("选中了边 " + sourceNode.name + ' -> ' + targetNode.name + ' (' + data.weight + ')');
    } else { // 点击的是点
        console.log("选中了" + data.name + '(' + data.value + ')');
    }
}
myChart.on(ecConfig.EVENT.CLICK, focus)

myChart.on(ecConfig.EVENT.FORCE_LAYOUT_END, function () {
    console.log(myChart.chart.force.getPosition());
});
                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );