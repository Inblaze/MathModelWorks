#include <bits/stdc++.h>
using namespace std;
const int INF = 2147483647; //2^31-1
const int MAXN = 6000006;

struct Edge {
	int to;//终点
	int w;//权值
	int next;//实际上是上一点
};

struct Node {
	int node;//编号
	int cost;

	bool operator<(const Node &a)const {
		return cost > a.cost;
	}
};

int node, edge, cnt = 1;
int vis[100000] = {0}; //结点数组
Edge edgeTo[MAXN];//与父节点
int head[MAXN];
int dis[MAXN];//得到父节点到其他点的最短路径

void init() {
	for (int i = 0; i < node; i++)
		head[i] = -1;
}

void adde(int from, int to, int w) {
	edgeTo[cnt].to = to;
	edgeTo[cnt].w = w;
	edgeTo[cnt].next = head[from]; //起始：next=-1;类似头插法，指针操作
	head[from] = cnt++; //起点的第一条边指向cnt

}

void Visit() {
	int u, v, w;
	init();
	cin >> node >> edge;

	for (int i = 0; i < edge; i++) {
		//输入格式为：起点-终点-权值
		cin >> u >> v >> w;
		adde(u, v, w);
		adde(v, u, w);
	}
}

int Prim(int start) { //起始节点
	for (int i = 1; i <= node; i++)
		dis[i] = INF;//初始化
	int cnt_node = 0, sum = 0;
	dis[start] = 0;
	priority_queue<Node>q;
	q.push(Node{start, 0});
	while (!q.empty()) {
		int u = q.top().node;
		q.pop();
		if (!vis[u]) {
			vis[u] = 1;
			cnt_node++;
			sum += dis[u];
			dis[u] = 0; //并入集合内部，因此dis=0
			for (int i = head[u]; i; i = edgeTo[i].next) {
				int &t = edgeTo[i].to;
				if (!vis[t] && dis[t] > dis[u] + edgeTo[i].w) {
					dis[t] = dis[u] + edgeTo[i].w;
					q.push(Node{t, dis[t]});
				}
			}
		}
	}

	if (cnt_node < node)
		sum = -1;
	return sum;
}

int main() {
	int s, sum = 0;
	Visit();//获得所有存在的边
	int n = Prim(1);
	if (n == -1)
		cout << "orz";
	else
		cout << n;
	return 0;
}