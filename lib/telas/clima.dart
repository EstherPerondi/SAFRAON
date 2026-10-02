import 'package:flutter/material.dart';
import 'package:safraon/variaveis.dart';
import '../services/clima_service.dart';

class ClimaPage extends StatefulWidget {
  final Map<String, String>? talhaoData;

  const ClimaPage({super.key, this.talhaoData});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final _service = ClimaService();
  bool _carregando = true;
  MetricasDiaInfo? _metricas;
  ClimaDiaInfo? _climaHoje;
  List<PrevisaoDiaInfo> _previsao = [];

  String get _talhaoId => widget.talhaoData?['id'] ?? '';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    if (_talhaoId.isEmpty) {
      setState(() => _carregando = false);
      return;
    }
    setState(() => _carregando = true);

    final resultados = await Future.wait([
      _service.getUltimasMetricas(_talhaoId),
      _service.getUltimoClima(_talhaoId),
      _service.getPrevisao(_talhaoId),
    ]);

    if (!mounted) return;
    setState(() {
      _metricas = resultados[0] as MetricasDiaInfo?;
      _climaHoje = resultados[1] as ClimaDiaInfo?;
      _previsao = resultados[2] as List<PrevisaoDiaInfo>;
      _carregando = false;
    });
  }

  IconData _iconeCondicao(String? nome) {
    switch (nome) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
      case 'Drizzle':
        return Icons.water_drop;
      case 'Thunderstorm':
        return Icons.thunderstorm;
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nome = widget.talhaoData?['nome'] ?? 'Talhão';
    final fazenda = widget.talhaoData?['fazenda'] ?? 'Fazenda';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Características climáticas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: VerdeEscuro,
        foregroundColor: Bege,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          color: Bege,
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _carregarDados,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            _buildTitle(nome, fazenda),
                            const SizedBox(height: 16),
                            _buildClimateMetrics(),
                            const SizedBox(height: 24),
                            _buildWeatherForecast(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTitle(String nome, String fazenda) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: BegeClaro,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _iconeCondicao(_climaHoje?.condicaoNome),
              color: VerdeEscuro,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Características - $nome',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: VerdeEscuro),
                    const SizedBox(width: 4),
                    Text(
                      fazenda,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClimateMetrics() {
    final tMin = _metricas?.temperaturaMin;
    final tMax = _metricas?.temperaturaMax;
    final temperaturaTexto = (tMin != null && tMax != null)
        ? '${tMin.toStringAsFixed(0)}-${tMax.toStringAsFixed(0)}'
        : '--';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BegeClaro,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados de hoje',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: VerdeClaro),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.thermostat,
                  label: 'Temp. mín-máx',
                  value: temperaturaTexto,
                  unit: '°C',
                  color: VerdeClaro,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.water_drop,
                  label: 'Umidade',
                  value: _metricas?.umidadeMedia?.toStringAsFixed(0) ?? '--',
                  unit: '%',
                  color: VerdeClaro,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.air,
                  label: 'Vento',
                  value: _metricas?.velocidadeVento?.toStringAsFixed(1) ?? '--',
                  unit: 'm/s',
                  color: VerdeClaro,
                ),
              ),
            ],
          ),
          if (_metricas == null && _climaHoje == null) ...[
            const SizedBox(height: 12),
            Text(
              'Ainda não há dados de clima registrados para este talhão.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  static const _diasSemana = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

  Widget _buildWeatherForecast() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BegeClaro,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: VerdeClaro, size: 25),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Previsão para os próximos dias',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: VerdeClaro),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_previsao.isEmpty)
            Text(
              'Ainda não há previsão registrada para este talhão.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            )
          else
            // SOLUÇÃO: Usando Row com Expanded para preencher todo o espaço
            Row(
              children: _previsao.asMap().entries.map((entry) {
                int index = entry.key;
                PrevisaoDiaInfo p = entry.value;
                
                return Expanded( // Mudança principal: de Flexible para Expanded
                  child: Padding(
                    padding: EdgeInsets.only(right: index == _previsao.length - 1 ? 0 : 12),
                    child: _buildForecastItem(
                      day: _diasSemana[p.data.weekday % 7],
                      tempMin: p.temperaturaMin,
                      tempMax: p.temperaturaMax,
                      icon: _iconeCondicao(p.condicaoNome),
                      color: VerdeEscuro,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildForecastItem({
    required String day,
    required double? tempMin,
    required double? tempMax,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Text(
            day, 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tempMin != null && tempMax != null
                  ? '${tempMin.toStringAsFixed(0)}°-${tempMax.toStringAsFixed(0)}°'
                  : '--',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
      ),
    );
  }
}