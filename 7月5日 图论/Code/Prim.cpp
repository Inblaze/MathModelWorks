#include <bits/stdc++.h>
using namespace std;
const int INF = 2147483647; //2^31-1
const int MAXN = 6000006;

struct Edge {
	int to;//�յ�
	int w;//Ȩֵ
	int next;//ʵ��������һ��
};

struct Node {
	int node;//���
	int cost;

	bool operator<(const Node &a)const {
		return cost > a.cost;
	}
};

int node, edge, cnt = 1;
int vis[100000] = {0}; //�������
Edge edgeTo[MAXN];//�븸�ڵ�
int head[MAXN];
int dis[MAXN];//�õ����ڵ㵽����������·��

void init() {
	for (int i = 0; i < node; i++)
		head[i] = -1;
}

void adde(int from, int to, int w) {
	edgeTo[cnt].to = to;
	edgeTo[cnt].w = w;
	edgeTo[cnt].next = head[from]; //��ʼ��next=-1;����ͷ�巨��ָ�����
	head[from] = cnt++; //���ĵ�һ����ָ��cnt

}

void Visit() {
	int u, v, w;
	init();
	cin >> node >> edge;

	for (int i = 0; i < edge; i++) {
		//�����ʽΪ�����-�յ�-Ȩֵ
		cin >> u >> v >> w;
		adde(u, v, w);
		adde(v, u, w);
	}
}

int Prim(int start) { //��ʼ�ڵ�
	for (int i = 1; i <= node; i++)
		dis[i] = INF;//��ʼ��
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
			dis[u] = 0; //���뼯���ڲ������dis=0
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
	Visit();//������д��ڵı�
	int n = Prim(1);
	if (n == -1)
		cout << "orz";
	else
		cout << n;
	return 0;
}