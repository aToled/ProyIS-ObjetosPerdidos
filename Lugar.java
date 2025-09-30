public class Lugar {
    private float longitud;
    private float latitud;
    private float radio;

    public Lugar(float longitud, float latitud) {
        this.longitud = longitud;
        this.latitud = latitud;
        this.radio=100;
    }

    public float getLongitud() {
        return longitud;
    }

    public float getLatitud() {
        return latitud;
    }

    public float getRadio() {
        return radio;
    }
}
