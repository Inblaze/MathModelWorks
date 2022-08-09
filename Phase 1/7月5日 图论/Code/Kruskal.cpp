#include <iostream>
#include <algorithm>
#include <queue>
using namespace std;

struct Edge {
	int u;//起点
	int v;//终点
	int w;//权值

	bool operator<(const Edge &a)const {
		return w > a.w;
	}
};

int node, edge; //总结点数以及边数
priority_queue<Edge> all_e;//存放所有的边
queue<Edge> vis_e;//加入最小生成树的所有的边
const int maxn = 1e5;
int father[maxn];

void Init() {
	for (int i = 1; i < maxn; i++) {
		father[i] = i;
	}
}

int Find(const int &u) { //查找u的祖宗是谁
	if (u == father[u])
		return u;
	return father[u] = Find(father[u]); //扁平化
}

void Union(const int &u, const int &v) { //联合
	father[Find(u)] = Find(v); //v的最老祖宗的爹是u的最老祖宗的爹
}

void Visit() {
	cout << "【请输入结点数以及边数】:" << endl;
	cin >> node >> edge;
	cout << "【请按照 起点-终点-权值 的格式输入边】：" << endl;
	for (int i = 0; i < edge; i++) {
		Edge a;
		cin >> a.u >> a.v >> a.w;
		all_e.push(a);
	}
}

int Kruskal() {
	int n_edge = 0, sum = 0;
	while (!all_e.empty()) {
		Edge a = all_e.top();
		all_e.pop();
		if (Find(a.u) != Find(a.v)) { //就加入这条边
			Union(a.u, a.v);
			vis_e.push(a);
			sum += a.w;
			n_edge++;
		}
	}
	if (n_edge < node - 1)
		sum = -1;
	return sum;
}

void Show() {
	while (!vis_e.empty()) {
		Edge a = vis_e.front();
		vis_e.pop();
		cout << a.u << " " << a.v << " " << a.w << endl;
	}
}

int main() {
	Init();
	Visit();
	cout << "===========" << endl;
	int n = Kruskal();
	if (n == -1)
		cout << "此图不连通" << endl;
	else {
		cout << n << endl;
		Show();
	}
	return 0;
}