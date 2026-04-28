class TravelSeed {
  const TravelSeed({
    required this.id,
    required this.title,
    required this.region,
    required this.country,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rating,
  });

  final String id;
  final String title;
  final String region;
  final String country;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final double rating;
}

const travelSeeds = <TravelSeed>[
  TravelSeed(
    id: 'lake-tekapo',
    title: 'Lake Tekapo',
    region: 'Oceania',
    country: 'New Zealand',
    category: 'Lake',
    description:
        'A clear alpine lake with turquoise water, quiet roads, and some of the darkest night skies in the world.',
    latitude: -44.0036,
    longitude: 170.4761,
    rating: 4.9,
  ),
  TravelSeed(
    id: 'santorini',
    title: 'Santorini',
    region: 'Europe',
    country: 'Greece',
    category: 'Coast',
    description:
        'Cliffside villages, whitewashed terraces, and a sea view that changes color from morning to dusk.',
    latitude: 36.3932,
    longitude: 25.4615,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'kyoto-temple',
    title: 'Kyoto Temple',
    region: 'Asia',
    country: 'Japan',
    category: 'Culture',
    description:
        'Temple gardens, cedar paths, and a slower rhythm that makes the city feel restorative.',
    latitude: 35.0116,
    longitude: 135.7681,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'banff',
    title: 'Banff National Park',
    region: 'North America',
    country: 'Canada',
    category: 'Mountain',
    description:
        'Glacial lakes, pine forests, and the kind of mountain skyline that looks edited even when it is not.',
    latitude: 51.4968,
    longitude: -115.9281,
    rating: 4.9,
  ),
  TravelSeed(
    id: 'amalfi-coast',
    title: 'Amalfi Coast',
    region: 'Europe',
    country: 'Italy',
    category: 'Coast',
    description:
        'Pastel towns stacked above the sea with cliff roads, lemon groves, and elegant harbor views.',
    latitude: 40.6333,
    longitude: 14.6020,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'reykjavik',
    title: 'Reykjavik Lights',
    region: 'Europe',
    country: 'Iceland',
    category: 'City',
    description:
        'A compact capital where hot springs, northern weather, and creative city energy meet in one place.',
    latitude: 64.1466,
    longitude: -21.9426,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'bali',
    title: 'Ubud Falls',
    region: 'Asia',
    country: 'Indonesia',
    category: 'Jungle',
    description:
        'Layered rice terraces, waterfall trails, and warm evenings framed by dense tropical green.',
    latitude: -8.5069,
    longitude: 115.2625,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'petra',
    title: 'Petra',
    region: 'Middle East',
    country: 'Jordan',
    category: 'Heritage',
    description:
        'Sandstone canyons open to carved facades, with color and scale that feel almost cinematic.',
    latitude: 30.3285,
    longitude: 35.4444,
    rating: 4.9,
  ),
  TravelSeed(
    id: 'mauritius',
    title: 'Mauritius Lagoon',
    region: 'Africa',
    country: 'Mauritius',
    category: 'Island',
    description:
        'Sheltered lagoons, coral water, and a relaxed shoreline that works for quiet escapes or water sports.',
    latitude: -20.3484,
    longitude: 57.5522,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'queenstown',
    title: 'Queenstown',
    region: 'Oceania',
    country: 'New Zealand',
    category: 'Adventure',
    description:
        'A mountain town built for scenery, speed, and lakeside evenings after a day outside.',
    latitude: -45.0312,
    longitude: 168.6626,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'machu-picchu',
    title: 'Machu Picchu',
    region: 'South America',
    country: 'Peru',
    category: 'Heritage',
    description:
        'Ancient stone terraces above the clouds, with a landscape that rewards the early wake-up.',
    latitude: -13.1631,
    longitude: -72.5450,
    rating: 4.9,
  ),
  TravelSeed(
    id: 'zermatt',
    title: 'Zermatt',
    region: 'Europe',
    country: 'Switzerland',
    category: 'Mountain',
    description:
        'A polished Alpine village shaped by skiing, hiking, and the dramatic silhouette of the Matterhorn.',
    latitude: 46.0207,
    longitude: 7.7491,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'cape-town',
    title: 'Cape Town',
    region: 'Africa',
    country: 'South Africa',
    category: 'City',
    description:
        'A city framed by ocean and table-top peaks, with beaches, markets, and viewpoints in every direction.',
    latitude: -33.9249,
    longitude: 18.4241,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'bora-bora',
    title: 'Bora Bora',
    region: 'Oceania',
    country: 'French Polynesia',
    category: 'Island',
    description:
        'Blue water, overwater stays, and a lagoon that looks almost unreal under bright daylight.',
    latitude: -16.5004,
    longitude: -151.7415,
    rating: 4.9,
  ),
  TravelSeed(
    id: 'tokyo',
    title: 'Tokyo Skyline',
    region: 'Asia',
    country: 'Japan',
    category: 'City',
    description:
        'A city of neon, precision, and hidden corners where food and design reward curiosity.',
    latitude: 35.6762,
    longitude: 139.6503,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'sydney',
    title: 'Sydney Opera House',
    region: 'Oceania',
    country: 'Australia',
    category: 'City',
    description:
        'Harbor light, iconic architecture, and a coastline that makes the whole city feel open.',
    latitude: -33.8568,
    longitude: 151.2153,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'prague',
    title: 'Prague Old Town',
    region: 'Europe',
    country: 'Czech Republic',
    category: 'Historic',
    description:
        'Cobblestones, bridges, and old facades that make even a short walk feel like a story.',
    latitude: 50.0755,
    longitude: 14.4378,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'rio',
    title: 'Rio de Janeiro',
    region: 'South America',
    country: 'Brazil',
    category: 'Beach',
    description:
        'A beachfront city with mountain backdrops, warm energy, and some of the best viewpoints in the world.',
    latitude: -22.9068,
    longitude: -43.1729,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'dubai',
    title: 'Dubai Marina',
    region: 'Middle East',
    country: 'United Arab Emirates',
    category: 'City',
    description:
        'A skyline of glass towers, waterfront promenades, and a hyper-modern travel feel.',
    latitude: 25.0800,
    longitude: 55.1400,
    rating: 4.6,
  ),
  TravelSeed(
    id: 'patagonia',
    title: 'Patagonia',
    region: 'South America',
    country: 'Argentina',
    category: 'Wild',
    description:
        'Remote peaks, open skies, and a sense of scale that is hard to capture in photos.',
    latitude: -50.0000,
    longitude: -73.0000,
    rating: 4.9,
  ),
  TravelSeed(
    id: 'lisbon',
    title: 'Lisbon Tram',
    region: 'Europe',
    country: 'Portugal',
    category: 'City',
    description:
        'Warm streets, tram lines, and an easy blend of old-world texture and coastal light.',
    latitude: 38.7223,
    longitude: -9.1393,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'seoul',
    title: 'Seoul Nightscape',
    region: 'Asia',
    country: 'South Korea',
    category: 'City',
    description:
        'Dense city energy, bright districts, and a nightlife rhythm that feels modern and fast.',
    latitude: 37.5665,
    longitude: 126.9780,
    rating: 4.7,
  ),
  TravelSeed(
    id: 'lucerne',
    title: 'Lucerne Lakeside',
    region: 'Europe',
    country: 'Switzerland',
    category: 'Lake',
    description:
        'A lake town with clean air, mountain reflections, and a slow, elegant pace.',
    latitude: 47.0502,
    longitude: 8.3093,
    rating: 4.8,
  ),
  TravelSeed(
    id: 'cairo',
    title: 'Cairo Nile',
    region: 'Africa',
    country: 'Egypt',
    category: 'City',
    description:
        'A river city with layered history, dense streets, and the Nile running through the center of it all.',
    latitude: 30.0444,
    longitude: 31.2357,
    rating: 4.7,
  ),
];
