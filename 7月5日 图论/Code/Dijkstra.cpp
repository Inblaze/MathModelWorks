#include <iostream>
#include <algorithm>
#include <queue>
#include <cstring>
using namespace std;
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
bool vis[MAXN];

void init();//head数组初始化
void add(int from, int to, int w); //链式前向星加边
void input();
void output();
void Dijkstra(int s);

int main() {
	input();
	Dijkstra(start);
	output();
	return 0;
}

void init() {
	for (int i = 0; i < node; i++)
		head[i] = -1;
}

void add(int from, int to, int w) {
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
	//一时间还没想好要写什么
	for (int i = 1; i <= node; i++)
		cout << disTo[i] << " ";
}

void Dijkstra(int s) {
	for (int i = 1; i <= node; i++)
		disTo[i] = INF;//初始化
	disTo[s] = 0; //考虑无自环，到自身的距离是0

	priority_queue<Node>q;
	q.push(Node{s, 0});
	memset(vis, false, sizeof(vis));//初始化，还未访问任何点

	while (!q.empty()) {
		int u = q.top().node;//得到起点编号
		q.pop();
		if (!vis[u]) {//该点未遍历过
			vis[u] = true;
			for (int i = head[u]; i; i = edgeTo[i].next) {
				int &t = edgeTo[i].to;
				if (!vis[t] && disTo[t] > disTo[u] + edgeTo[i].w) {
					disTo[t] = disTo[u] + edgeTo[i].w;
					q.push(Node{t, disTo[t]});
				}
			}
		}
	}
}