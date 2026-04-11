import 'package:flutter/material.dart';
import 'new_transaction_dialog.dart';

class FinanceDesktop extends StatefulWidget {
  const FinanceDesktop({super.key});

  @override
  State<FinanceDesktop> createState() => _FinanceDesktopState();
}

class _FinanceDesktopState extends State<FinanceDesktop> {
  // Lista de transações simulando o banco de dados
  final List<Map<String, dynamic>> _transacoes = [
    {'descricao': 'Venda Balcão (Dinheiro)', 'tipo': 'Receita', 'valor': 150.00, 'data': '11/04/2026'},
    {'descricao': 'Pagamento Fornecedor (Bebidas)', 'tipo': 'Despesa', 'valor': 350.00, 'data': '10/04/2026'},
    {'descricao': 'Venda Ifood', 'tipo': 'Receita', 'valor': 85.50, 'data': '09/04/2026'},
    {'descricao': 'Conta de Luz', 'tipo': 'Despesa', 'valor': 220.00, 'data': '08/04/2026'},
    {'descricao': 'Venda Balcão (Cartão)', 'tipo': 'Receita', 'valor': 420.00, 'data': '08/04/2026'},
    {'descricao': 'Taxa Maquininha', 'tipo': 'Despesa', 'valor': 12.50, 'data': '08/04/2026'},
  ];

  // Cálculos dinâmicos
  double get _totalReceitas => _transacoes.where((t) => t['tipo'] == 'Receita').fold(0, (sum, item) => sum + item['valor']);
  double get _totalDespesas => _transacoes.where((t) => t['tipo'] == 'Despesa').fold(0, (sum, item) => sum + item['valor']);
  double get _saldoAtual => _totalReceitas - _totalDespesas;

  @override
  Widget build(BuildContext context) {
    // === LÓGICA DE RESPONSIVIDADE ===
    final double width = MediaQuery.of(context).size.width;
    final bool isSmall = width < 800;
    final bool isVerySmall = width < 500;
    
    final double paddingGeral = isSmall ? 20 : 32;
    final double headerTextSize = isSmall ? 26 : 32;
    final int kpiCrossAxisCount = isVerySmall ? 1 : (isSmall ? 2 : 3);

    return Padding(
      padding: EdgeInsets.all(paddingGeral),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Text(
                'Financeiro / Caixa',
                style: TextStyle(fontSize: headerTextSize, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Nova Transação',
                  style: TextStyle(fontSize: isSmall ? 16 : 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 28, vertical: isSmall ? 14 : 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                onPressed: () async {
                  final novaTransacao = await showNewTransactionDialog(context);
                  if (novaTransacao != null) {
                    setState(() {
                      // Adiciona a nova transação no topo da lista
                      _transacoes.insert(0, novaTransacao);
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Transação registrada!'), backgroundColor: Colors.green)
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPIs (Cards de Resumo)
          GridView.count(
            crossAxisCount: kpiCrossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true, // Para não dar erro de layout dentro da Column
            childAspectRatio: isSmall ? 2.2 : 2.5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildKpiCard('Saldo Atual', _saldoAtual, Icons.account_balance_wallet, _saldoAtual >= 0 ? const Color(0xFF0055FF) : Colors.red),
              _buildKpiCard('Receitas (Mês)', _totalReceitas, Icons.arrow_upward_rounded, Colors.green),
              _buildKpiCard('Despesas (Mês)', _totalDespesas, Icons.arrow_downward_rounded, Colors.red),
            ],
          ),
          const SizedBox(height: 24),

          // Gráfico e Lista
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gráfico (Esconde em telas muito pequenas)
                if (!isVerySmall) ...[
                  Expanded(
                    flex: 2,
                    child: _buildChartCard(),
                  ),
                  const SizedBox(width: 24),
                ],
                
                // Lista de Transações
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Últimas Transações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _transacoes.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _transacoes[index];
                              final isReceita = item['tipo'] == 'Receita';
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor: isReceita ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                                  child: Icon(
                                    isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                                    color: isReceita ? Colors.green : Colors.red,
                                  ),
                                ),
                                title: Text(item['descricao'], style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(item['data'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                trailing: Text(
                                  '${isReceita ? '+' : '-'} R\$ ${item['valor'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isReceita ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para os Cards de KPI
  Widget _buildKpiCard(String title, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  'R\$ ${value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para o Gráfico Nativo Mockado (Para rodar sem dependências)
  Widget _buildChartCard() {
    // Dados fictícios para as barras do gráfico (Seg a Dom)
    final dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final valores = [0.3, 0.5, 0.4, 0.8, 1.0, 0.7, 0.2]; // Altura relativa (0.0 a 1.0)

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Receitas da Semana', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(dias.length, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Barra
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: valores[index], // Pega a altura do array mockado
                        child: Container(
                          width: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0055FF), // Azul principal do seu app
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Texto do dia
                    Text(dias[index], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}