#include <iostream>
#include <algorithm>
#include <queue>
using namespace std;

struct Edge {
	int u;//���
	int v;//�յ�
	int w;//Ȩֵ

	bool operator<(const Edge &a)const {
		return w > a.w;
	}
};

int node, edge; //�ܽ�����Լ�����
priority_queue<Edge> all_e;//������еı�
queue<Edge> vis_e;//������С�����������еı�
const int maxn = 1e5;
int father[maxn];

void Init() {
	for (int i = 1; i < maxn; i++) {
		father[i] = i;
	}
}

int Find(const int &u) { //����u��������˭
	if (u == father[u])
		return u;
	return father[u] = Find(father[u]); //��ƽ��
}

void Union(const int &u, const int &v) { //����
	father[Find(u)] = Find(v); //v���������ڵĵ���u���������ڵĵ�
}

void Visit() {
	cout << "�������������Լ�������:" << endl;
	cin >> node >> edge;
	cout << "���밴�� ���-�յ�-Ȩֵ �ĸ�ʽ����ߡ���" << endl;
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
		if (Find(a.u) != Find(a.v)) { //�ͼ���������
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
		cout << "��ͼ����ͨ" << endl;
	else {
		cout << n << endl;
		Show();
	}
	return 0;
}