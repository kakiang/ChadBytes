import 'package:flutter_test/flutter_test.dart';
import 'dart:convert' as convert;

import 'package:geschehen/model/database.dart';

void main() {
  test("parses feed.json", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // var jsonString = await rootBundle.loadString("assets/feed.json");
    var json = convert.jsonDecode(jsonString);
    var list = List<Article>.from(json.map((e) => Article.fromJson(e["doc"])));
    expect(list, isNotEmpty);
  });
}

const jsonString = '''
[
    {
        "doc": {
            "title": "Burkina Faso : L'ex-président Compaoré bientôt jugé pour l'assassinat de Sankara",
            "link": "https://www.alwihdainfo.com/Burkina-Faso-L-ex-president-Compaore-bientot-juge-pour-l-assassinat-de-Sankara_a102559.html",
            "thumbnail": "https://www.alwihdainfo.com/photo/art/large_x2_16_9/55472430-41517080.jpg?v=1618329623",
            "published": "2021-04-13T00:00:00Z",
            "audio_link": "",
            "video_link": "",
            "summary": "En exil en Côte d'Ivoire depuis sa chute en 2015,...",
            "content": "Trente-quatre ans après la mort de Thomas Sankara, le 'père de la Révolution' burkinabè, 'l'heure de la justice a enfin sonné, un procès peut s'ouvrir', s'est réjoui Me Guy Hervé Kam, avocat des parties civiles. L'ex-président du Burkina Faso Blaise Compaoré, actuellement en exil en Côte d'Ivoire, va être jugé pour l'assassinat de son prédécesseur lors du coup d'État de 1987 qui l'a porté au pouvoir.      En effet, le dossier de l'homicide du panafricaniste Thomas Sankara a été renvoyé ce 13 avril devant le tribunal militaire de Ouagadougou. Après la confirmation des charges contre les principaux accusés, dont Blaise Compaoré, selon des avocats de la défense et des parties civiles, le dossier a été renvoyé devant le tribunal militaire de Ouagadougou, au Burkina Faso. 'Il s'agit essentiellement de Blaise Compaoré et de 13 autres, accusés d'attentat à la sûreté de l'État', 'complicité d'assassinats' et 'complicité de recel de cadavres', a déclaré Me Guy Hervé Kam.      Parmi les personnes mises en cause initialement, beaucoup d'accusés sont décédés. On y trouve également le général Gilbert Diendéré, l'un des principaux chefs de l'armée lors du putsch de 1987, devenu ensuite chef d'état-major particulier de Blaise Compaoré, ainsi que des soldats de l'ex-garde présidentielle. Le général purge actuellement au Burkina Faso une peine de 20 ans de prison pour une tentative de coup d'État en 2015. Arrivé au pouvoir par un coup d'État en 1983, le président Sankara a été tué par un commando le 15 octobre 1987 à 38 ans, lors du putsch qui porta au pouvoir son compagnon d'armes d'alors, Blaise Compaoré.      La mort de Sankara, surnommé le 'Che Africain', était un sujet tabou pendant les 27 ans de pouvoir de Blaise Compaoré, lui-même renversé par une insurrection populaire en 2014. Après la chute de Blaise Compaoré, l'affaire a été relancée, par le régime de transition démocratique. Un mandat d'arrêt international avait alors été émis contre lui par la justice burkinabè en décembre 2015. Depuis sa chute, Blaise Compaoré, exilé en Côte d’Ivoire a obtenu la nationalité ivoirienne et ne peut donc pas être extradé. Cela dit, il devrait être jugé par contumace.",
            "publisher": "https://www.alwihdainfo.com/"
        }
    },
    {
        "doc": {
            "title": "Élections au Tchad : 'l'atmosphère du scrutin était apaisée' (mission CEN-SAD)",
            "link": "https://www.alwihdainfo.com/Elections-au-Tchad-l-atmosphere-du-scrutin-etait-apaisee-mission-CEN-SAD_a102551.html",
            "thumbnail": "https://www.alwihdainfo.com/photo/art/large_x2_16_9/55465602-41513176.jpg?v=1618313363",
            "published": "2021-04-13T00:00:00Z",
            "audio_link": "",
            "video_link": "",
            "summary": "La mission d'observation électorale de la Communauté des...",
            "content": "La mission d'observation électorale de la Communauté des Sahélo-sahariens (CEN-SAD) a conclu lundi que le gouvernement et la Commission électorale nationale indépendante (CENI) ont pris les dispositions adéquates pour assurer un scrutin libre, transparent et dans les conditions optimales de sécurité. Elle relève un accès équitable des candidats aux médias.      Selon la mission de la CEN-SAD, l'atmosphère du scrutin était apaisée dans la plupart des 22.863 bureaux de vote, tandis qu'il y a eu une bonne accessibilité, dans de bonnes conditions, aux bureaux de vote.      Elle relève quelques insuffisances (non maitrise par certains agents des procédures du scrutin, faiblesse de l'éclairage dans certains bureaux de vote au moment du dépouillement, non observation par les électeurs des mesures barrières) mais estime toutefois qu'elles ne sont pas de nature à entacher la transparence, la régularité et la crédibilité du scrutin.      La CEN-SAD félicite les forces de défense et de sécurité pour leur mobilisation et leurs actions déterminantes pour la sécurisation du processus électoral sur toute l'étendue du territoire tchadien.      La CEN-SAD a déployé une centaine d'observateurs répartis en vingtaine d'équipes. La mission a été conduite par l'ancien Premier ministre du Mali, Soumeylou Boubeye Maïga, assisté du secrétaire exécutif de la CEN-SAD, Ibrahim Sani Abani, et composée de personnalités d'une quinzaine de pays.       ",
            "publisher": "https://www.alwihdainfo.com/"
        }
    },
    {
        "doc": {
            "title": "Présidentielle au Tchad : des résultats partiels attendus ce mardi",
            "link": "https://www.alwihdainfo.com/Presidentielle-au-Tchad-des-resultats-partiels-attendus-ce-mardi_a102546.html",
            "thumbnail": "https://www.alwihdainfo.com/photo/art/large_x2_16_9/55464623-41512485.jpg?v=1618310060",
            "published": "2021-04-13T00:00:00Z",
            "audio_link": "",
            "video_link": "",
            "summary": "Le chargé de la communication de la Commission électorale...",
            "content": "Le chargé de la communication de la Commission électorale nationale indépendante (CENI) a affirmé lundi que des résultats partiels du scrutin présidentiel du 11 avril seront dévoilés ce mardi.      Les résultats seront publiés quotidiennement, jusqu'au 25 avril, date de proclamation provisoire des résultats.      7.288.203 électeurs recensés dans le fichier électoral étaient attendus aux urnes pour le scrutin présidentiel. Parmi les électeurs enregistrés, 50,76% sont des femmes et 49,24% des hommes. ",
            "publisher": "https://www.alwihdainfo.com/"
        }
    }
]
''';
