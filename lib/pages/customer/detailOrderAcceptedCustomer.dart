import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trackit_dev/models/coordinatePoint.dart';
import 'package:trackit_dev/models/orderCustomerProcessed.dart';
import 'package:trackit_dev/providers/customerProvider.dart';
import 'package:trackit_dev/providers/otherProvider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailOrderAcceptedCustomerPage extends StatefulWidget {
  static const String routeName = '/detailOrderAcceptedCustomer';

  const DetailOrderAcceptedCustomerPage({super.key});

  @override
  State<DetailOrderAcceptedCustomerPage> createState() =>
      _DetailOrderAcceptedCustomerPageState();
}

class _DetailOrderAcceptedCustomerPageState
    extends State<DetailOrderAcceptedCustomerPage> {
  List<LatLng> routePoints = [];
  bool isLoading = true;

  Coordinate? coorPengirim;
  Coordinate? coorPenerima;

  LatLng? startPoint;
  LatLng? endPoint;

  Future<void> fetchRoute() async {
    final url =
        'http://router.project-osrm.org/route/v1/driving/${startPoint!.longitude},${startPoint!.latitude};${endPoint!.longitude},${endPoint!.latitude}?geometries=geojson';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ambil koordinat rute dari response OSRM
      final coords = data['routes'][0]['geometry']['coordinates'] as List;

      // Konversi ke List<LatLng> (ingat: OSRM format koordinat = [longitude, latitude])
      final points =
          coords
              .map((point) => LatLng(point[1] as double, point[0] as double))
              .toList();

      setState(() {
        routePoints = points;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch route');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider = Provider.of<CustomerProvider>(
        context,
        listen: false,
      );

      final OrderCustomerProcessedModel order =
          ModalRoute.of(context)?.settings.arguments
              as OrderCustomerProcessedModel;

      await customerProvider.getCoordinatesPoint(
        idPengirim: order.idKecamatanPengirim,
        idPenerima: order.idKecamatanPenerima,
      );

      final coordinateModel = customerProvider.coordinatePoint;

      if (coordinateModel != null) {
        if (coordinateModel.pengirim.isNotEmpty &&
            coordinateModel.penerima.isNotEmpty) {
          coorPengirim = coordinateModel.pengirim[0];
          coorPenerima = coordinateModel.penerima[0];

          startPoint = LatLng(coorPengirim!.latitude, coorPengirim!.longitude);
          endPoint = LatLng(coorPenerima!.latitude, coorPenerima!.longitude);
        }
      }

      await fetchRoute();
    });
  }

  Widget rowData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 10, child: Text(':')),
          Expanded(
            child: Text(
              value == '' ? '-' : value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderCustomerProcessedModel order =
        ModalRoute.of(context)?.settings.arguments
            as OrderCustomerProcessedModel;

    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final otherProvider = Provider.of<OtherProvider>(context);
    final dataJenisPaket = otherProvider.dataJenisPaket!;
    final dataKecamatan = otherProvider.dataKecamatan!;

    String getNamaJenisPaket(int id) {
      final jenis = dataJenisPaket.firstWhere(
        (item) => item['id_jenis'] == id,
        orElse: () => null,
      );
      if (jenis != null) {
        return jenis['nama_jenis'] ?? '-';
      } else {
        return '-';
      }
    }

    String getNamaKecamatan(int id) {
      final kecamatan = dataKecamatan.firstWhere(
        (item) => item['id_kecamatan'] == id,
        orElse: () => null,
      );
      if (kecamatan != null) {
        return kecamatan['nama_kecamatan'] ?? '-';
      } else {
        return '-';
      }
    }

    List<Tab> tabBar = [Tab(text: 'Informasi'), Tab(text: 'Tracking')];

    return DefaultTabController(
      length: tabBar.length,
      child: Scaffold(
        backgroundColor: Color(0xFFECF0F1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.12,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Detail Order',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            bottom: TabBar(
              tabs: tabBar,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF1F3A93), width: 4),
                insets: EdgeInsets.symmetric(horizontal: 8),
              ),
              unselectedLabelStyle: TextStyle(
                color: Color(0xFFD9D9D9),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengirim",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        children: [
                          rowData('Nama', order.namaPengirim),
                          rowData('Nomor Telepon', order.teleponPengirim),
                          rowData(
                            'Kecamatan',
                            getNamaKecamatan(order.idKecamatanPengirim),
                          ),
                          rowData('Alamat', order.detailAlamatPengirim),
                          //[{id_kecamatan: 5, nama_kecamatan: Ambulu}, {id_kecamatan: 6, nama_kecamatan: Wuluhan}]
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Penerima",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        children: [
                          rowData('Nama', order.namaPenerima),
                          rowData('Nomor Telepon', order.teleponPenerima),
                          rowData(
                            'Kecamatan',
                            getNamaKecamatan(order.idKecamatanPenerima),
                          ),
                          rowData('Alamat', order.detailAlamatPenerima),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Order",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        children: [
                          rowData(
                            'Jenis Barang',
                            getNamaJenisPaket(order.idJenisPaket),
                          ),
                          rowData('Berat', '${order.beratPaket} Kg'),
                          rowData(
                            'Waktu Order',
                            order.createdAt.toIso8601String(),
                          ),
                          rowData('Catatan Kurir', order.catatanKurir!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child:
                        isLoading || startPoint == null || endPoint == null
                            ? const Center(child: CircularProgressIndicator())
                            : FlutterMap(
                              options: MapOptions(
                                initialCenter: startPoint!,
                                initialZoom: 12.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                ),
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: routePoints,
                                      strokeWidth: 5.5,
                                      color: const Color.fromARGB(
                                        167,
                                        54,
                                        101,
                                        255,
                                      ),
                                    ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: startPoint!,
                                      child: const Icon(
                                        Icons.circle,
                                        color: Color(0xFF1F3A93),
                                        size: 15,
                                      ),
                                    ),
                                    Marker(
                                      point: endPoint!,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF1F3A93),
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
