package uk.ac.open.ouanywhere;

import android.util.Base64;
import java.io.UnsupportedEncodingException;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.*;

/**
 * Encryption/Decryption class, encrypts/decrypts a string
 *
 * @author Nigel Clarke <nigel.clarke@pentahedra.com>
 */
public class Crypto extends CordovaPlugin {

    String data;
    private final String passphrase = "LikethelegendofthephoenixAllendswithbeginningsWhatkeepstheplanetspinningTheforceoflovebeginning";
    private SecretKeySpec key;
    private Cipher cipher;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        JSONObject dataJSON = args.getJSONObject(0);
        data = dataJSON.getString("data");

        try {
            byte[] salt = "f1d15a957439e5131600e72553fb3b3369a52cd95640613743defda3".getBytes("UTF-8");
            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            SecretKey tmpKey = factory.generateSecret(new PBEKeySpec(passphrase.toCharArray(), salt, 65536, 128));
            key = new SecretKeySpec(tmpKey.getEncoded(), "AES");
            cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");

            if (action.equals("encrypt")) {
                String cipherText = encrypt(data);
                callbackContext.success(cipherText);
            } else if (action.equals("decrypt")) {
                String clearText = decrypt(data);
                callbackContext.success(clearText);
            }
        } catch (InvalidKeyException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IllegalBlockSizeException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (BadPaddingException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NoSuchPaddingException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvalidKeySpecException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvalidAlgorithmParameterException ex) {
            Logger.getLogger(Crypto.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }

    public String encrypt(String string) throws InvalidKeyException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException {
        String ivString = "kjs7iwy281on022l";
        IvParameterSpec ivSpec = new IvParameterSpec(ivString.getBytes());

        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] stringBytes = string.getBytes("UTF-8");
        byte[] encryptedBytes = cipher.doFinal(stringBytes);
        return Base64.encodeToString(encryptedBytes, Base64.DEFAULT);
    }

    public String decrypt(String string) throws InvalidKeyException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException, InvalidAlgorithmParameterException {
        String ivString = "kjs7iwy281on022l";
        IvParameterSpec ivSpec = new IvParameterSpec(ivString.getBytes());
        cipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
        byte[] stringBytes = Base64.decode(string, Base64.DEFAULT);
        byte[] decryptedBytes = cipher.doFinal(stringBytes);
        return new String(decryptedBytes, "UTF-8");
    }
}
