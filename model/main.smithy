namespace software.chucho

use aws.protocols#restJson1

@restJson1
service Bookings {
    version: "2020-04-15",
    resources: [Place]
}


///place01-2020-04-15-12:00
resource Booking {
    identifiers: {bookingId: String, placeId: String},
    create: CreateBooking,
    operations: [MoveBooking]
}

operation CreateBooking {
    input: CreateBookingInput,
    output: CreateBookingOutput,
    errors: [NoSuchResource, AlreadyBooked]
}

structure CreateBookingInput {}

structure CreateBookingOutput {}

operation MoveBooking {
    input: MoveBookingInput,
    output: MoveBookingOutput,
    errors: [NoSuchResource, AlreadyBooked]
}

structure MoveBookingInput {}

structure MoveBookingOutput {}

@error("client")
structure AlreadyBooked {
    @required
    resourceType: String
}


resource Place {
    identifiers: { placeId: String },
    read: GetPlace,
    list: ListPlaces,
    create: CreatePlace,
    delete: DeletePlace,
    update: UpdatePlace,
    resources: [Booking]
}

@references([{resource: Place}])
structure PlaceSummary {
    placeId: String,
    name: String,
    description: String,
    category: String,
    location: Location
}

@readonly
@http(method: "GET", uri: "/places")
operation ListPlaces {
    input: ListPlacesInput,
    output: ListPlacesOutput
}

structure ListPlacesInput {
    @httpQuery("contains")
    contains: String
}

list PlacesList {
    member: PlaceSummary
}

structure ListPlacesOutput {
    places: PlacesList
}


@http(method: "POST", uri: "/places")
operation CreatePlace {
    input: CreatePlaceInput,
    output: CreatePlaceOutput
}

structure CreatePlaceInput {
    @required
    name: String,
    @required
    description: String,
    @required
    category: String,
    @required
    location: Location
}

structure CreatePlaceOutput {
    place: PlaceSummary
}

@idempotent
@http(method: "DELETE", uri: "/places/{placeId}")
operation DeletePlace {
    input: DeletePlaceInput,
    output: DeletePlaceOutput,
    errors: [NoSuchResource]
}

structure DeletePlaceInput {
    @required
    @httpLabel
    placeId: String
}


structure DeletePlaceOutput {
    place: PlaceSummary
}


@idempotent
@http(method: "PUT", uri: "/places/{placeId}")
operation UpdatePlace {
    input: UpdatePlaceInput,
    output: UpdatePlaceOutput,
    errors: [NoSuchResource]
}

structure UpdatePlaceInput {
    @required
    @httpLabel
    placeId: String,
    @required
    name: String,
    @required
    description: String,
    @required
    category: String,
    @required
    location: Location
}


structure UpdatePlaceOutput {
    place: PlaceSummary
}



@readonly
@http(method: "GET", uri: "/places/{placeId}")
operation GetPlace {
    input: GetPlaceInput,
    output: GetPlaceOutput,
    errors: [NoSuchResource]
}

structure GetPlaceInput {
    @required
    @httpLabel
    placeId: String
}

structure GetPlaceOutput {
    place: PlaceSummary
}

structure Location {
    @required
    lat: Latitude,
    @required
    lng: Longitude
}

@range(min: -90, max: 90)
integer Latitude

@range(min: -180, max: 180)
integer Longitude


@error("client")
structure NoSuchResource {
    @required
    resourceType: String
}
