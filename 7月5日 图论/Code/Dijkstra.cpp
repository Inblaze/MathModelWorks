#include <iostream>
#include <algorithm>
#include <queue>
#include <cstring>
using namespace std;
const int INF = 2147483647; //2^31-1 
const int MAXN = 6000006;

struct Edge {
	int to;//�յ�
	int w;//Ȩֵ
	int next;//ʵ��������һ��
};//ǰ����-��̬�������ڽӱ�

struct Node { //���Խ������ȶ���
	int node;//���
	int cost;//����ñ�Ž��Ĵ���
	bool operator<(const Node &n)const {
		return cost > n.cost;
	}
};

Edge edgeTo[MAXN];//�븸�ڵ�
int head[MAXN];
int disTo[MAXN];//�õ����ڵ㵽����������·��
int node, edge, start, cnt = 1; //������������������㡢��ʽǰ���Ǽ���
bool vis[MAXN];

void init();//head�����ʼ��
void add(int from, int to, int w); //��ʽǰ���Ǽӱ�
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
	edgeTo[cnt].next = head[from]; //��ʼ��next=-1;����ͷ�巨��ָ�����
	head[from] = cnt++; //���ĵ�һ����ָ��cnt

}

void input() {
	int from, to, w;
	init();//��ʼ��
	cin >> node >> edge >> start;
	for (int i = 0; i < edge; i++) {
		cin >> from >> to >> w;
		add(from, to, w);
	}
}

void output() {
	//һʱ�仹û���Ҫдʲô
	for (int i = 1; i <= node; i++)
		cout << disTo[i] << " ";
}

void Dijkstra(int s) {
	for (int i = 1; i <= node; i++)
		disTo[i] = INF;//��ʼ��
	disTo[s] = 0; //�������Ի���������ľ�����0

	priority_queue<Node>q;
	q.push(Node{s, 0});
	memset(vis, false, sizeof(vis));//��ʼ������δ�����κε�

	while (!q.empty()) {
		int u = q.top().node;//�õ������
		q.pop();
		if (!vis[u]) {//�õ�δ������
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