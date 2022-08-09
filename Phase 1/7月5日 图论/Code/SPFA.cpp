#include <iostream>
#include <algorithm>
#include <queue>
using namespace std;
//BF算法
const int INF = 2147483647; //2^31-1
const int MAXN = 6000006;

struct Edge {
	int to;//终点
	int w;//权值
	int next;//实际上是上一点
};//前向星-静态建立的邻接表

struct Node { //用以建立优先队列
	int node;//编号
	int cost;//到达该编号结点的代价
	bool operator<(const Node &n)const {
		return cost > n.cost;
	}
};

Edge edgeTo[MAXN];//与父节点
int head[MAXN];
int disTo[MAXN];//得到父节点到其他点的最短路径
int node, edge, start, cnt = 1; //点总数、边总数、起点、链式前向星计数
queue<Node>q;
int onQ[MAXN] = {0};

void init();//head数组初始化
void add(const int &, const int &, const int &); //链式前向星加边
void input();
void output();
void relax();
void SPFA(const int &);

int main() {
	input();
	SPFA(start);
	output();
	return 0;

}

void init() {
	for (int i = 0; i < node; i++)
		head[i] = -1;
}

void add(const int &from, const int &to, const int &w) {
	edgeTo[cnt].to = to;
	edgeTo[cnt].w = w;
	edgeTo[cnt].next = head[from]; //起始：next=-1;类似头插法，指针操作
	head[from] = cnt++; //起点的第一条边指向cnt

}

void input() {
	int from, to, w;
	init();//初始化
	cin >> node >> edge >> start;
	for (int i = 0; i < edge; i++) {
		cin >> from >> to >> w;
		add(from, to, w);
	}
}

void output() {
	for (int i = 1; i <= node; i++)
		cout << disTo[i] << " ";
}

void relax(int u) {
	for (int i = head[u]; i; i = edgeTo[i].next) {
		int &t = edgeTo[i].to;
		if (disTo[t] > disTo[u] + edgeTo[i].w) {
			disTo[t] = disTo[u] + edgeTo[i].w;
			if (!onQ[t]) {
				onQ[t] = 1;
				q.push(Node{t, disTo[t]});
			}

		}
	}
}

void SPFA(const int &s) { //起点
	for (int i = 1; i <= node; i++)
		disTo[i] = INF;//初始化
	disTo[s] = 0; //考虑无自环，到自身的距离是0
	q.push(Node{s, 0});
	onQ[s] = 1;

	while (!q.empty()) {
		int u = q.front().node;
		q.pop();
		onQ[u] = 0;
		relax(u);
	}

}