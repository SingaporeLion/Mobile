import 'package:flutter/material.dart';

final scamTokens = [
  {
    "logo": "assets/logos/alacamel.png",
    "name": "AlaCamel",
    "address": "0x123fkkkt353w2533tg89AB",
    "reason": "Rugpull + 90% owned by Devs"
  },
  {
    "logo": "assets/logos/pupucoin.png",
    "name": "PupuCoin",
    "address": "0x98742gst3345gsre65CD",
    "reason": "Honeypot detected"
  },
];

final dummyHistory = [
  {"name": "ShadyDoge", "risk": "green"},
  {"name": "\$RUGME", "risk": "red"},
];

class RiskScannerScreen extends StatefulWidget {
  const RiskScannerScreen({Key? key}) : super(key: key);

  @override
  State<RiskScannerScreen> createState() => _RiskScannerScreenState();
}

class _RiskScannerScreenState extends State<RiskScannerScreen> {
  final _addressController = TextEditingController();
  bool _scanning = false;
  String? _riskLevel; // "green", "yellow", "red"
  String? _riskReason;

  void _dummyScan() {
    setState(() {
      _scanning = true;
      _riskLevel = null;
      _riskReason = null;
    });

    // Simuliere "KI-Analyse"
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _scanning = false;
        _riskLevel = "red";
        _riskReason = "Honeypot, >95% Supply locked";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Risk Scanner"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- SCAM-ALERT BANNER ---
            Container(
              height: 42,
              color: Colors.red[50],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: scamTokens.length,
                itemBuilder: (context, idx) {
                  final scam = scamTokens[idx];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.red[100], borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Image.asset(scam["logo"]!, width: 28, height: 28),
                        const SizedBox(width: 8),
                        Text(
                          "${scam["name"]} (${scam["address"]})",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Reason: ${scam["reason"]}",
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // --- Risk Scanner Input ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Wallet / Token / Contract-Adresse",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      // TODO: QR-Scanner einbauen
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // --- KI-Button und Normal-Button nebeneinander ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _scanning ? null : _dummyScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: _scanning
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Icon(Icons.shield, color: Colors.white),
                  label: const Text("Mit KI prüfen (Empfohlen)"),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _scanning ? null : _dummyScan,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.deepPurple, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Risiko jetzt prüfen"),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // --- KI VISUALISIERUNG ---
            if (_scanning)
              Column(
                children: [
                  const Icon(Icons.shield_outlined, size: 48, color: Colors.deepPurple),
                  const SizedBox(height: 6),
                  Text(
                    "SolMind AI analysiert...",
                    style: TextStyle(
                        color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple[200], borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            // --- Ergebnis-Anzeige / RiskCard ---
            if (_riskLevel != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 4,
                  color: _riskLevel == "red"
                      ? Colors.red[100]
                      : _riskLevel == "yellow"
                      ? Colors.orange[100]
                      : Colors.green[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _riskLevel == "red"
                                  ? Icons.error
                                  : _riskLevel == "yellow"
                                  ? Icons.warning
                                  : Icons.check_circle,
                              color: _riskLevel == "red"
                                  ? Colors.red
                                  : _riskLevel == "yellow"
                                  ? Colors.orange
                                  : Colors.green,
                              size: 34,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _riskLevel == "red"
                                  ? "Risk Level: HOCH"
                                  : _riskLevel == "yellow"
                                  ? "Risk Level: MITTEL"
                                  : "Risk Level: NIEDRIG",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _riskLevel == "red"
                                      ? Colors.red
                                      : _riskLevel == "yellow"
                                      ? Colors.orange[900]
                                      : Colors.green[700]),
                            ),
                            const Spacer(),
                            Image.asset("assets/ai_gpt_logo.png", width: 32),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _riskReason ?? "",
                          style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Details-Dialog oder Extra-Seite
                          },
                          child: const Text("Details anzeigen"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // --- History (Letzte geprüfte) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Zuletzt geprüft:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: dummyHistory.length,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => SizedBox(height: 4),
                    itemBuilder: (context, idx) {
                      final item = dummyHistory[idx];
                      return Row(
                        children: [
                          Icon(
                            item["risk"] == "red" ? Icons.error : Icons.check_circle,
                            color: item["risk"] == "red" ? Colors.red : Colors.green,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            item["name"]!,
                            style: TextStyle(
                                fontSize: 15,
                                color: item["risk"] == "red" ? Colors.red : Colors.green[700]),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // --- Info / Community ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "SolMind AI schützt dich in Echtzeit vor bekannten Scams und neuen Bedrohungen. "
                    "Die Risikoanalyse basiert auf modernster KI-Technologie und Community-Power.",
                style: TextStyle(color: Colors.deepPurple[700], fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}