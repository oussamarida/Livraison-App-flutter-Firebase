
import 'package:last_livrai/screens/pages/Menu.dart';

List<Category> loadCategories() {
  return [
    Category(
      name: "Italian",
      image:
          "https://img.freepik.com/photos-gratuite/pates-fraiches-bolognaise-copieuse-fromage-parmesan-genere-par-ia_188544-9469.jpg?w=996&t=st=1700178157~exp=1700178757~hmac=7f63d409af21e9508e7e601d28825582292900e5e9c9698a511c5fa9c9c8531a",
      foods: [
        FoodItem(
          name: "Margherita Pizza",
          description: "Classic pizza with tomatoes, mozzarella, and basil",
          price: 12.99,
          image:
              "https://img.freepik.com/photos-premium/pizza-brulee-processus-fabrication-pizza-echoue-cuisinier-preparant-pizza-margherita_636803-2236.jpg?w=996",
        ),
        FoodItem(
          name: "Pasta Carbonara",
          description: "Creamy pasta with eggs, cheese, and pancetta",
          price: 14.99,
          image:
              "https://img.freepik.com/photos-gratuite/spaghetti-aux-ingredients-melanges-dans-assiette-blanche_114579-15091.jpg?w=996&t=st=1700177811~exp=1700178411~hmac=e0251a009fd887b7530f0de62382aceaec6b3cf5f54a40baee8ae7031e5827e2",
        ),
        FoodItem(
          name: "Lasagna",
          description:
              "Layered pasta with ricotta, meat sauce, and mozzarella cheese",
          price: 15.99,
          image:
              "https://img.freepik.com/photos-gratuite/lasagne-classique-sauce-bolognaise_2829-11251.jpg?w=996&t=st=1700177837~exp=1700178437~hmac=b9dc185f8be90ff04e02959fe1ab2f0b40a0adc5f152bd8f240b7bb2d1e32b40",
        ),
        FoodItem(
          name: "Risotto",
          description: "Creamy rice dish cooked with broth and Parmesan cheese",
          price: 13.99,
          image:
              "https://img.freepik.com/photos-gratuite/risotto-aux-fruits-mer-sauce-tomate-garnie-crevettes_141793-1954.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
        FoodItem(
          name: "Tiramisu",
          description:
              "Coffee-flavored dessert made with ladyfingers and mascarpone cheese",
          price: 10.99,
          image:
              "https://img.freepik.com/photos-gratuite/delicieux-gateau-dans-arrangement-verre_23-2149030735.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
      ],
    ),
    Category(
      name: "Japanese",
      image:
          "https://img.freepik.com/photos-gratuite/peinture-sushi-assiette-photo-poisson-dessus_188544-12221.jpg?w=996&t=st=1700178071~exp=1700178671~hmac=f2b80276228d776b3980ff6c78bb39d48cbce66e85541a0b5101d7397a2db5d0",
      foods: [
        FoodItem(
          name: "Sushi Platter",
          description: "Assorted sushi with fresh fish and vegetables",
          price: 22.99,
          image:
              "https://img.freepik.com/photos-gratuite/vue-laterale-melanger-rouleaux-sushi-plateau-du-gingembre-du-wasabi_141793-14242.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais",
        ),
        FoodItem(
          name: "Ramen",
          description: "Traditional noodle soup with pork, eggs, and scallions",
          price: 13.99,
          image:
              "https://img.freepik.com/photos-gratuite/delicieux-ramen-surface-sombre_1150-41971.jpg?w=996&t=st=1700178688~exp=1700179288~hmac=54fae05437ad832f85209e5305686b07742cfd6719407735aa3336702960b625",
        ),
        FoodItem(
          name: "Tempura",
          description: "Lightly battered and fried seafood or vegetables",
          price: 14.99,
          image:
              "https://img.freepik.com/photos-gratuite/batonnets-poulet-frit-servis-laitue-legumes-verts_141793-723.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais",
        ),
        FoodItem(
          name: "Sashimi",
          description: "Sliced raw fish served with soy sauce and wasabi",
          price: 20.99,
          image:
              "https://img.freepik.com/photos-gratuite/sushi-au-restaurant-asiatique_23-2148195573.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais",
        ),
        FoodItem(
          name: "Matcha Ice Cream",
          description: "Green tea flavored ice cream",
          price: 5.99,
          image:
              "https://img.freepik.com/photos-gratuite/glace-menthe-au-chocolat-plat_23-2150096671.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais",
        ),
      ],
    ),
    Category(
      name: "Mexican ",
      image:
          "https://img.freepik.com/photos-gratuite/tacos-mexicains-au-boeuf-sauce-tomate-salsa_2829-14218.jpg?w=996&t=st=1700178276~exp=1700178876~hmac=817fa696b0ad56f96fc0fbe9628a4a372a229d3781ae002251184abb2a9dd6eb",
      foods: [
        FoodItem(
          name: "Taco",
          description:
              "A traditional Mexican dish consisting of a folded or rolled tortilla filled with various ingredients.",
          price: 9.99,
          image:
              "https://img.freepik.com/photos-gratuite/doner-viande-dans-du-pain-pita-planche-bois_140725-9872.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
        FoodItem(
          name: "Guacamole",
          description:
              "A creamy avocado-based dip with tomatoes, onions, and spices.",
          price: 6.99,
          image:
              "https://img.freepik.com/photos-gratuite/sauce-guacamole-chaude-faite-maison-nachos-vue-dessus_114579-7079.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
        FoodItem(
          name: "Enchiladas",
          description:
              "Rolled tortillas filled with meat and topped with sauce and cheese.",
          price: 11.99,
          image:
              "https://img.freepik.com/photos-premium/enchiladas-vertes-rouges-sauces-mexicaines_839035-180472.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
        FoodItem(
          name: "Churros",
          description:
              "Deep-fried dough pastries sprinkled with sugar and cinnamon.",
          price: 4.99,
          image:
              "https://img.freepik.com/photos-gratuite/fond-noir-churros-papier-emballage_23-2148379659.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
        FoodItem(
          name: "Margarita",
          description:
              "A classic Mexican cocktail made with tequila, lime juice, and orange liqueur.",
          price: 8.99,
          image:
              "https://img.freepik.com/photos-gratuite/boissons-glacees-pretes-etre-servies_23-2148617689.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=sph",
        ),
      ],
    ),
    Category(
      name: "Sweets",
      image:
          "https://img.freepik.com/photos-gratuite/variete-patisseries-planches-bois_114579-17198.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for sweets
      foods: [
        FoodItem(
          name: "Chocolate Cake",
          description: "Rich and indulgent chocolate cake",
          price: 9.99,
          image:
              "https://img.freepik.com/photos-gratuite/vue-face-composition-goodies-boulangerie-sucree_23-2148653996.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for chocolate cake
        ),
        FoodItem(
          name: "Ice Cream Sundae",
          description: "A delightful ice cream sundae with toppings",
          price: 6.99,
          image:
              "https://img.freepik.com/photos-gratuite/boules-glace-biscuits_140725-1801.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for ice cream sundae
        ),
        FoodItem(
          name: "Cheesecake",
          description: "Creamy cheesecake with a graham cracker crust",
          price: 8.99,
          image:
              "https://img.freepik.com/photos-gratuite/vue-cote-gateau-au-fromage-aux-fraises_140725-11353.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for cheesecake
        ),
        FoodItem(
          name: "Brownie",
          description: "Fudgy brownie with chocolate chips",
          price: 5.99,
          image:
              "https://img.freepik.com/photos-gratuite/support-refroidissement-angle-eleve-brownies-bouilloire_23-2148569710.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for brownie
        ),
        FoodItem(
          name: "Cupcake",
          description: "Decorative cupcake with frosting and sprinkles",
          price: 3.99,
          image:
              "https://img.freepik.com/photos-gratuite/tir-vertical-delicieux-petits-gateaux-creme-du-sucre-poudre-cerise-livres_181624-28944.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for cupcake
        ),
  FoodItem(
      name: "Red Velvet Cake",
      description: "Classic red velvet cake with cream cheese frosting",
      price: 7.99,
      image: "https://img.freepik.com/photos-gratuite/tranches-gateau-velours-rouge-cerise-dessus-feuilles-menthe_114579-2593.jpg?size=626&ext=jpg&ga=GA1.1.1423313029.1696620534&semt=ais", // Replace with the image URL for red velvet cake
    ),
      ],
    ),
  ];
}
