<%@ page language="java" import="spare.*"
	contentType="text/html;charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="kiben" content="no-cache">
<title>Knowledge Map</title>
<script src="js/esl.js"></script>
</head>

<body>
	<%
		int minDis = 0;
		int maxDis = Integer.MAX_VALUE;

		String[] vertices = {"补角的定义", "余角的定义", "锐角的定义",
				"三角形的分类", "直角的定义", "直角三角形的定义",
				"等腰直角三角形", "直角三角形定理",
				"直角三角形的属性",
				"角的属性","角的定义"};
		int[][] weight = {{-1, 1, -1, -1, -1, -1, -1, -1, -1, -1,-1},
				{-1, -1, -1, -1, -1, -1, -1, 5, -1, -1,-1},
				{-1, -1, -1, -1, -1, -1, -1, 4, -1, -1,-1},
				{-1, -1, -1, -1, -1, 3, 3, -1, -1, -1,-1},
				{-1, -1, -1, -1, -1, 1, -1, -1, -1, -1,-1},
				{-1, -1, -1, -1, -1, -1, -1, 2, 3, -1,2},
				{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,-1},
				{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,-1},
				{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,-1},
				{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,3},
				{-1, -1, -1, 1, -1, -1, -1, -1, -1, -1,-1}};

		try {
			new SharedResources(weight, vertices, "角的定义",
					"直角三角形定理", "等腰直角三角形");
			PathJudgement path = new PathJudgement(
					"com.microsoft.sqlserver.jdbc.SQLServerDriver",
					"jdbc:sqlserver://localhost:1433", "Learning", "sa",
					"123456", 1);
			int nextNode = path.judgePath();
			if(nextNode == -1)
				System.out.println("不需要引导");
			else 
				System.out.println(vertices[nextNode]);
			//new DisplayUSMap();
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>

	<div id="main" style="height: 500px"></div>
	<script type="text/javascript">
        // 路径配置
        require.config({
            paths:{ 
                echarts : 'js/echarts',
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
    color:["#01B468","#005AB5","#0080FF","#66B3FF"],
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
        x: 'center',
        data:['目标结点','掌握较差','掌握一般','掌握较好']
    },
    series : [
        {
            type:'force',
            name : "知识地图",
            ribbonType: false,
            categories : [
                {
                    name: '目标结点'
                },
                {
                	 name: '掌握较差',
                	 symbol: 'rectangle'
                   
                },
                {
                	 name: '掌握一般',
                	 symbol: 'diamond'
                },
                {
                    name:'掌握较好',
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
    if ( data.source != null && data.target != null ) { //点击的是边
        var sourceNode = nodes.filter(function (n) {return n.name == data.source})[0];
        var targetNode = nodes.filter(function (n) {return n.name == data.target})[0];
        console.log("选中了边 " + sourceNode.name + ' -> ' + targetNode.name + ' (' + data.weight + ')');
    } else { // 点击的是点
        console.log("选中了" + data.name + '(' + data.value + ')');
    }
}
myChart.on(ecConfig.EVENT.CLICK, focus);

myChart.on(ecConfig.EVENT.FORCE_LAYOUT_END, function () {
    console.log(myChart.chart.force.getPosition());
});
                    
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
</body>
</html>